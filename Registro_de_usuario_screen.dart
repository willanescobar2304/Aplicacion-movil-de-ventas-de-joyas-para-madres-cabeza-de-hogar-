// ignore_for_file: unused_import, must_be_immutable, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/subir_imagen.dart';
// ignore: depend_on_referenced_packages

import '../home/home_screens.dart';

class RegistroUsuario extends StatefulWidget {
    static const String name = 'cards';
      const RegistroUsuario({super.key, });

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  File? imagen;
  UrlImagen url = UrlImagen();
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController nombreUsuario = TextEditingController();
  TextEditingController numeroCedula = TextEditingController();
  TextEditingController numeroTelefono = TextEditingController();
  TextEditingController correoElectronico = TextEditingController();
  TextEditingController direccionDeRecidencia = TextEditingController();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    
    bool usuarioRepetido = false;
    
    bool usuarioRepetidoSalir = false;
    

    
    final firebase = FirebaseFirestore.instance;
    final formkey = GlobalKey<FormState>();
    var logger = Logger(printer: PrettyPrinter());

Future<void> selecionarImaden(val) async{
  
  var pickedFile;

  if(val == 1){
    pickedFile = await picker.pickImage(source: ImageSource.camera);
  }
  else{
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  }
  setState(() {
    if(pickedFile!=null){
      imagen = File(pickedFile.path);
      // cortarImagen(File(pickedFile.path));
    }
    else{

    }
  });

  Navigator.pop(context);
}



imagenOpciones(BuildContext context) async{
  
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: ()async{
                  await selecionarImaden(1);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border:  Border(bottom: BorderSide(width: 1,color: Color.fromARGB(255, 160, 228, 255)))
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('Tomar una foto',style: TextStyle(fontSize: 20),), 
                      ),
                      Icon(Icons.camera_alt,color: Colors.black,)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                 await selecionarImaden(2);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('Cargar una foto',style: TextStyle(fontSize: 20),), 
                      ),
                      Icon(Icons.image,color: Colors.black,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  );

}




  validarDatos(String url) async{
  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    }
  );
  try{
    CollectionReference ref= firebase.collection('Usuarios');
    QuerySnapshot usuarios = await ref.get();
    if(usuarios.docs.isNotEmpty){
      for(var documento in usuarios.docs){
        if(documento.get('Numero de cedula')==numeroCedula.text.trim()){
          usuarioRepetidoSalir = true;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistroUsuario()));
          showDialog(
            context:context,
            builder:(BuildContext context){
              return AlertDialog(
                title: const Text('Este numero de cedula ya se encuentra registrado',textAlign: TextAlign.center,),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                      child: const Text('Aceptar',style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                    ),
                  )
                ],
              );
            }
          );
          // nombre.clear();
          // apellidos.clear();
          // nombreUsuario.clear();
          // numeroCedula.clear();
          // numeroTelefono.clear();
          // correoElectronico.clear();
          // direccionDeRecidencia.clear();
        }
        else{
          usuarioRepetido = true;
        }
      }
      if(usuarioRepetido == true && usuarioRepetidoSalir == false){
        try{
            await firebase.collection('Usuarios').doc().set(
              {
                "Nombre":nombre.text,
                "Apellido":apellidos.text,
                "Nombre de usuario":nombreUsuario.text.trim(),
                "Numero de cedula":numeroCedula.text.trim(),
                "Numero de celular":numeroTelefono.text,
                "Correo electronico":correoElectronico.text,
                "Direccion de recidencia":direccionDeRecidencia.text,
                "Imagen":url,
                "Clave":numeroCedula.text.trim()
              }
            );
            // const CircularProgressIndicator();
          }catch(e){
            logger.i('Error'+e.toString());
          }
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistroUsuario()));
          showDialog(
            context: context,
            builder: (BuildContext contex){
              return AlertDialog(
                title: const Text('Usuario registrado', textAlign: TextAlign.center,),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                    child: const Text('Aceptar',textAlign: TextAlign.center,style: TextStyle(color: Colors.white))
                  )
                ],
              );
            }
          );
          // nombre.clear();
          // apellidos.clear();
          // nombreUsuario.clear();
          // numeroCedula.clear();
          // numeroTelefono.clear();
          // correoElectronico.clear();
          // direccionDeRecidencia.clear();
      }
    }
    else if(usuarios.docs.isEmpty){
      try{
            await firebase.collection('Usuarios').doc().set(
              {
                "Nombre":nombre.text,
                "Apellido":apellidos.text,
                "Nombre de usuario":nombreUsuario.text.trim(),
                "Numero de cedula":numeroCedula.text.trim(),
                "Numero de celular":numeroTelefono.text,
                "Correo electronico":correoElectronico.text,
                "Direccion de recidencia":direccionDeRecidencia.text,
                "Imagen":url,
                "Clave":numeroCedula.text.trim()
              }
            );
          }catch(e){
            logger.i('Error'+e.toString());
          }
          
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistroUsuario()));
          showDialog(
            context: context,
            builder: (BuildContext contex){
              return AlertDialog(
                title: const Text('Usuario registrado', textAlign: TextAlign.center,),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                    child: const Text('Aceptar',textAlign: TextAlign.center,style: TextStyle(color: Colors.white))
                  )
                ],
              );
            }
          );
          // nombre.clear();
          // apellidos.clear();
          // nombreUsuario.clear();
          // numeroCedula.clear();
          // numeroTelefono.clear();
          // correoElectronico.clear();
          // direccionDeRecidencia.clear();
    }
  }catch(e){
    logger.i('Error'+e.toString());
  }
}

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 118, 193, 1),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back) 
        ),
      ),
      body: SingleChildScrollView(    
        child:  Stack(
          children: [
          Form(
            key: formkey,
             child: Column(
                    children: [
                    Container(
                      color: const Color.fromARGB(255, 223, 246, 255)
                    ),
                    const Center(
                      child: TextoInicio(
                      texto:"Para registrarse, suministre la siguiente información.",
                      fuente: 1.2,
                      horizontal: 10,
                      vertical: 10,
                      alto: 70,
                      ancho: 300,
                      color: Color.fromARGB(255, 2, 118, 193),
                      fuenteColor: Colors.white,
                      colorBorde: Color.fromARGB(255, 2, 118, 193),
                      distancia: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200
                        ),
                        child: Center(
                          child: imagen == null
                          ? const Text(
                            "Imagen no seleccionada",
                            textAlign: TextAlign.center,
                          )
                          :CircleAvatar(
                            backgroundImage: FileImage(imagen!),
                            radius: 100,
                          )
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 1),
                      child: IconButton(
                        onPressed: ()async{
                          imagenOpciones(context);
                        },
                        icon: const Icon(Icons.photo_camera)
                      ),
                    ),
                      
                    Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: nombre,
                              keyboardType: TextInputType.name,
                              decoration:const  InputDecoration(
                                labelText: 'Nombre',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Nombre',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ),
             
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: apellidos,
                              keyboardType: TextInputType.name,
                              decoration:const  InputDecoration(
                                labelText: 'Apellido',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Apellido',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ),
             
                    Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: nombreUsuario,
                              keyboardType: TextInputType.name,
                              decoration:const  InputDecoration(
                                labelText: 'Nombre de Usuario',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Nombre de Usuario',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ), 
             
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: numeroCedula,
                              keyboardType: TextInputType.number,
                              decoration:const  InputDecoration(
                                labelText: 'Número de cédula',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Número de cédula',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ),
             
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: numeroTelefono,
                              keyboardType: TextInputType.number,
                              decoration:const  InputDecoration(
                                labelText: 'Número de celular',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Número de celular',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ), 
             
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: correoElectronico,
                              keyboardType: TextInputType.name,
                              decoration:const  InputDecoration(
                                labelText: 'Correo electrónico',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Correo electrónico',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ), 
             
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: SizedBox(
                            width: 305,
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Por favor ingrese un valor';
                                }
                                return null;
                              },
                              controller: direccionDeRecidencia,
                              keyboardType: TextInputType.name,
                              decoration:const  InputDecoration(
                                labelText: 'Direccion de recidencia',
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Direccion de recidencia',
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                            ),
                          ),
                        ),                                                            
                      ElevatedButton(
                        onPressed: () async {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));                                                             
                          if(imagen==null){
                            showDialog(
                              context: context,
                              builder: (context){
                                return const AlertDialog(
                                  title: Text('Debes cargar una imagen a tu perfil'),
                                );
                              }
                            );
                          }
                          else{
                              if(formkey.currentState!.validate()){ 
                              final upload = await url.subirImagen(imagen!,nombre.text+apellidos.text,numeroCedula.text,"Usuarios",context,);
                              await validarDatos(url.url).then((value){
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: const Text('Recuerda que el nombre de usuario que registraste y el número de tu documento, que será tu clave, son indispensables para iniciar sesión'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                                          child: const Text('Aceptar',style: TextStyle(color: Colors.white),)
                                        )
                                      ],
                                    );
                                  }
                                );
                              });
                              // if(await upload){
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text("Imagen cargada"),
                              //     backgroundColor: Color.fromARGB(255, 2, 118, 193)
                              //   )
                              //   );
                              // }
                            }
                          }
                                          
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 113, 193)),
                        child: const Text("Registrar", style: TextStyle(color: Colors.white)),
                        )
                    ],
                  ),
             
           ),
          
          ]
        )
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}





class TextoInicio extends StatelessWidget {
   const TextoInicio({
    super.key,
    required this.horizontal,
    required this.vertical,
    required this.texto,
    required this.fuente,
    required this.alto,
    required this.ancho,
    required this.color,
    required this.fuenteColor,
    required this.colorBorde,
    required this.distancia
    });
  final double horizontal;
  final double vertical;
  final String texto;
  final double fuente;
  final double alto;
  final double ancho;
  final Color color;
  final Color fuenteColor;
  final Color colorBorde;
  final double distancia; 

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
      mainAxisSize: MainAxisSize.max ,
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: [
        SizedBox(height: distancia,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: Border.all(
              width: 1,
              color: colorBorde
            )
          ),
          height: alto,
          width: ancho,
          child:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
            child: Text(texto, textScaleFactor: fuente, style: TextStyle(color: fuenteColor), textAlign: TextAlign.center,),
          ),
        )
      ],
      ),
    );
  }
}