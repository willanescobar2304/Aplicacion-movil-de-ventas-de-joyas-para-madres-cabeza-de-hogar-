// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_app/Presentation/screens/edicion_de_usuario/actualizar_datos_usuario.dart';
import 'package:widgets_app/Presentation/screens/edicion_de_usuario/cambio_contrase%C3%B1a.dart';
import '../../lista-funciones/funciones/agregar_imagen.dart';
import '../../lista-funciones/funciones/subir_imagen.dart';

class EditarDadosDelUsuario extends StatefulWidget {
  final String idDocumentoUsuario;
  const EditarDadosDelUsuario({super.key, required this.idDocumentoUsuario});

  @override
  State<EditarDadosDelUsuario> createState() => _EditarDadosDelUsuarioState();
}
  File? imagen_to_upload;
  UrlImagen urlimagen = UrlImagen();
  

class _EditarDadosDelUsuarioState extends State<EditarDadosDelUsuario> {

  String idDocumentoUsuario = '';

  @override
  void didUpdateWidget(EditarDadosDelUsuario oldWidget) {
    super.didUpdateWidget(oldWidget);
    datosusuario();
  }

  Future<void> datosusuario() async{
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference ref = db.collection('Usuarios').doc(widget.idDocumentoUsuario);
      DocumentSnapshot documento = await ref.get();
      if(documento.exists){
        setState(() {
        nombret = documento.get('Nombre');
        apellidot = documento.get('Apellido');
        nombredeUsuariot = documento.get('Nombre de usuario');
        numeroDeCedulat = documento.get('Numero de cedula');
        numerodeCelulart = documento.get('Numero de celular');
        correoElectronicot = documento.get('Correo electronico');
        direccionDerecidenciat = documento.get('Direccion de recidencia');
        imagenUsuario = documento.get('Imagen');
        idDocumentoUsuario = documento.id;  
        });
        
      }
      else{
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Text('El usuario no existe'),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar')
                )
              ],
            );
          }
        );
      }
    }catch(e){
      showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            title: Text('¡Ups hubo un problema!'),
          );
        } 
      );
    }
  }

  @override
  void didChangeDependencies(){
    datosusuario();
    super.didChangeDependencies();
  }

  @override
  // ignore: override_on_non_overriding_member
  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController nombredeUsuario = TextEditingController();
  TextEditingController numeroDeCedula = TextEditingController();
  TextEditingController numerodeCelular = TextEditingController();
  TextEditingController correoElectronico = TextEditingController();
  TextEditingController direccionDerecidencia = TextEditingController();

  String nombret = '';
  String apellidot = '';
  String nombredeUsuariot = '';
  String numeroDeCedulat = '';
  String numerodeCelulart = '';
  String correoElectronicot = '';
  String direccionDerecidenciat = ''; 
  String imagenUsuario = '';

  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    UrlImagen urlImagen = UrlImagen();
    nombre.text = nombret;
    apellido.text = apellidot;
    nombredeUsuario.text = nombredeUsuariot;
    numeroDeCedula.text = numeroDeCedulat;
    numerodeCelular.text = numerodeCelulart;
    correoElectronico.text = correoElectronicot;
    direccionDerecidencia.text = direccionDerecidenciat;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edita tus datos',style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child:  Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                  Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: Center(
                          child: imagen_to_upload == null
                          ?CircleAvatar(
                            backgroundImage: NetworkImage(imagenUsuario),
                            radius: 200,
                          )
                          :CircleAvatar(
                            backgroundImage: FileImage(imagen_to_upload!),
                            radius: 200,
                          )
                        )
                      ),
                    ),
                IconButton(
                  onPressed: () async{
                    final imagen = await getImagen();
                      setState((){
                        imagen_to_upload = File(imagen!.path);
                      });
                      if(imagen_to_upload != null){
                        showDialog(
                          context: context,
                          builder: (contex){
                            return const AlertDialog(
                              title: Text("Imagen seleccionada"),
                            );
                          }
                        );
                      }
                  },
                  icon: const Icon(Icons.add_a_photo_rounded,color:  Color.fromARGB(255, 2, 118, 193),size: 50,)
                ),
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SizedBox(
                    width: 350,
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
                    width: 350,
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
                      controller: apellido,
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
                    width: 350,
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
                      controller: nombredeUsuario,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        labelText: 'Nombre de usuario',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Nombre de usuario',
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
                    width: 350,
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
                      controller: numeroDeCedula,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        labelText: 'Numero de cedula',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Numero de cedula',
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
                    width: 350,
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
                      controller: numerodeCelular,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        labelText: 'Numero de teléfono',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Numero de teléfono',
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
                    width: 350,
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
                      controller: correoElectronico,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        labelText: 'Correo electronico',
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
                    width: 350,
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
                      controller: direccionDerecidencia,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        labelText: 'Dirección de recidencia',
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
                  onPressed: () async{


                    if(formkey.currentState!.validate()){
                      if(imagen_to_upload != null){
                        final upload = await urlImagen.subirImagen(imagen_to_upload!,'${nombre.text} ${apellido.text}', numeroDeCedulat,"Usuarios",context);
                        if(upload){
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            actionOverflowThreshold: 1,
                            content: Text("Imagen cargada"),
                            backgroundColor: Color.fromARGB(255, 2, 118, 193)
                          )
                        );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("La imagen no pudo cargarse"),
                            backgroundColor: Color.fromARGB(255, 2, 118, 193)
                          )
                        );
                        }
                      }
                      if(imagen_to_upload == null){
                        await actualizarDatosUsuario(widget.idDocumentoUsuario, nombre.text, apellido.text, nombredeUsuario.text, numeroDeCedula.text, numerodeCelular.text, correoElectronico.text, direccionDerecidencia.text, imagenUsuario, context).then((value){
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text('¡Los datos fueron modificados!'),
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
                      }
                      else{
                      await actualizarDatosUsuario(widget.idDocumentoUsuario, nombre.text, apellido.text, nombredeUsuario.text, numeroDeCedula.text, numerodeCelular.text, correoElectronico.text, direccionDerecidencia.text, urlImagen.url, context).then((value){
                            showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text('¡Los datos fueron modificados!'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                                    child: const Text('Aceptar')
                                  )
                                ],
                              );
                            }
                          );
                      });
                    }
                      setState(() {
                        imagen_to_upload == null;
                        nombret;
                        apellidot;
                        nombredeUsuariot;
                        numeroDeCedulat;
                        numerodeCelulart;
                        correoElectronicot;
                        direccionDerecidenciat;                      
                      });
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: Size(120, 50)),
                  child: const Text("Editar",style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,)),
                TextButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CambioDeClave(idDocumentoUsuario: idDocumentoUsuario)));
                  },
                  icon: const Icon(Icons.vpn_key,color: Color.fromARGB(255, 2, 118, 193),),
                  label: const Text('¿Quieres cambiar tu contraseña?',style: TextStyle(color: Color.fromARGB(255, 2, 118, 193)),)
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 201, 236, 250),
    );
  }
}