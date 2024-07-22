// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/agregar_imagen.dart';
//import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';
import 'package:widgets_app/services/firebase_services.dart';

import 'subir_imagen.dart';



class AgregarArticulo extends StatefulWidget{
  const AgregarArticulo({super.key});

  @override
  State<AgregarArticulo> createState() => _AgregarArticuloState();
}
  // ignore: non_constant_identifier_names
  File? imagen_to_upload;
  UrlImagen urlimagen = UrlImagen();
  List<String> opciones = ['Cadena','Manilla','Anillo','Arete'];
  String tipoArticulo = 'Cadena';
  TextEditingController nombreArticulo = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController precio = TextEditingController();
  TextEditingController codigo = TextEditingController();
  TextEditingController cantidad = TextEditingController();
  

class _AgregarArticuloState extends State<AgregarArticulo> {
  @override
  Widget build(BuildContext context) {

    

    //TextEditingController tipoAticulo = TextEditingController();
    
    
    final formkey = GlobalKey<FormState>();

    UrlImagen urlImagen = UrlImagen();
    
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            setState(() {
              imagen_to_upload = null;
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body:SingleChildScrollView(
          child: Center(
            child: Form(
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
                          ? const Text(
                            "Imagen no seleccionada",
                            textAlign: TextAlign.center,
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
                    icon: const Icon(Icons.add_a_photo_outlined,size: 50,color: Color.fromARGB(255, 2, 118, 193),)
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
                      controller: nombreArticulo,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Nombre del artículo',
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
                    height: 60,
                    child: DropdownButtonFormField(
                      value: tipoArticulo.trim(),
                      items: opciones.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: (String? valureIn){
                        setState(() {
                          tipoArticulo = valureIn ?? '';
                        });
                      },
                      decoration: const InputDecoration(
                        helperStyle: TextStyle(color: Colors.black),
                        hoverColor: Colors.white,
                        focusedBorder: InputBorder.none,
                        hintText: 'Tipo de artículo',
                        filled: true,
                        labelText: 'Tipo de artículo',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(                  
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        )
                      ),
                    ),
                  ),
                ),



                // Padding(
                // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //   child: SizedBox(
                //     width: 350,
                //     height: 50,
                //     child: TextFormField(
                //       inputFormatters: [
                //         FilteringTextInputFormatter.singleLineFormatter
                //       ],
                //       validator: (value) {
                //         if(value!.isEmpty){
                //           return 'Por favor ingrese un valor';
                //         }
                //         return null;
                //       },
                //       controller: tipoAticulo,
                //       keyboardType: TextInputType.name,
                //       decoration:const  InputDecoration(
                //         errorBorder: InputBorder.none,
                //         focusedErrorBorder: InputBorder.none,
                //         hintText: 'Tipo articulo',
                //         hintStyle: TextStyle(color: Colors.black26),
                //         filled: true,
                //         fillColor: Colors.white,
                //         border:  OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(5))
                //         )
                //       ),
                //     ),
                //   ),
                // ),

                     AutoSizeTextFormField(
                      controller: descripcion,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Descripción',
                        hintStyle: TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.white, 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        )
                      ),
                    ),
                


                // Padding(
                // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //   child: SizedBox(
                //     width: 350,
                //     height: 50,
                //     child: AutoSizeTextFormField(
                //       maxLines: 55,
                //       inputFormatters: [
                //         FilteringTextInputFormatter.singleLineFormatter
                //       ],
                //       validator: (value) {
                //         if(value!.isEmpty){
                //           return 'Por favor ingrese un valor';
                //         }
                //         return null;
                //       },
                //       controller: descripcion,
                //       keyboardType: TextInputType.name,
                //       decoration:const  InputDecoration(
                        
                //         focusedErrorBorder: InputBorder.none,
                //         hintText: 'Descripcion',
                //         hintStyle: TextStyle(color: Colors.black26),
                //         filled: true,
                //         fillColor: Colors.white,
                //         border:  OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(5))
                //         )
                //       ),
                //     ),
                //   ),
                // ),


                //   Padding(
                // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //   child: SizedBox(
                //     width: 350,
                //     height: 50,
                //     child: TextFormField(
                //       inputFormatters: [
                //         FilteringTextInputFormatter.singleLineFormatter
                //       ],
                //       validator: (value) {
                //         if(value!.isEmpty){
                //           return 'Por favor ingrese un valor';
                //         }
                //         return null;
                //       },
                //       controller: descripcion,
                //       keyboardType: TextInputType.name,
                //       decoration:const  InputDecoration(
                //         errorBorder: InputBorder.none,
                //         focusedErrorBorder: InputBorder.none,
                //         hintText: 'Descripcion',
                //         hintStyle: TextStyle(color: Colors.black26),
                //         filled: true,
                //         fillColor: Colors.white,
                //         border:  OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(5))
                //         )
                //       ),
                //     ),
                //   ),
                // ),
                  
                  Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                        ThousandsSeparatorInputFormatter()
                      ],
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Por favor ingrese un valor';
                        }
                        return null;
                      },
                      controller: precio,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Precio',
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
                      controller: codigo,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Código',
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
                      controller: cantidad,
                      keyboardType: TextInputType.number,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Cantidad',
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
                      // if(agregarImagen.imagen == null){
                      //   return; 
                      // }
                      // final subir = await subirImagen(agregarImagen.imagen! as File);
                      if(imagen_to_upload != null){
                        final upload = await urlImagen.subirImagen(imagen_to_upload!,tipoArticulo, nombreArticulo.text,"Aticulos",context);
                        if(upload){
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                      await agregarProductos(
                        nombreArticulo.text,
                        tipoArticulo,
                        descripcion.text,
                        precio.text,
                        codigo.text,
                        cantidad.text,
                        urlImagen.url,
                        context
                      ).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Producto agregado"),
                              backgroundColor: Color.fromARGB(255, 2, 118, 193),
                            )
                          );
                      });
                      

                      }
                      nombreArticulo.clear();
                      descripcion.clear();
                      precio.clear();
                      codigo.clear();
                      cantidad.clear();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(120, 50)),
                    child: const Text("Agregar",style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,)),
                ],
              ),
            ),
          ),
        ),
      backgroundColor: const Color.fromARGB(255, 209, 241, 254),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      final numericValue = int.tryParse(newValue.text.replaceAll(',', ''));
      final formattedValue = NumberFormat('#,##0', 'es_CO')
          .format(numericValue ?? 0)
          .replaceAll('.', ',');
      return newValue.copyWith(text: formattedValue, selection: TextSelection.collapsed(offset: formattedValue.length));
    }
    return newValue;
  }
}