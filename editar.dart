// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/agregar_imagen.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/busqueda_de_productos.dart';
import 'package:widgets_app/services/firebase_services.dart';

import 'agregar.dart';
import 'subir_imagen.dart';

class EditarArticulos extends StatefulWidget {
  final String nombreArticuloP;
  final String tipoArticuloP;
  final String descripcionP;
  final String precioP;
  final String codigoP;
  final String cantidadP;
  final String imagen;
  final String uid;
  const EditarArticulos({super.key, required this.nombreArticuloP, required this.tipoArticuloP, required this.descripcionP, required this.precioP, required this.codigoP, required this.cantidadP, required this.uid, required this.imagen});

  @override
  State<EditarArticulos> createState() => _EditarArticulosState();
}
  File? imagen_to_upload;
  UrlImagen urlimagen = UrlImagen();
  List<String> opciones = ['Cadena','Manilla','Anillo','Arete'];
  String tipoAticulo = '';
  

class _EditarArticulosState extends State<EditarArticulos> {
  @override
  Widget build(BuildContext context) {

    TextEditingController nombreArticulo = TextEditingController();
    // TextEditingController tipoAticulo = TextEditingController();
    TextEditingController descripcion = TextEditingController();
    TextEditingController precio = TextEditingController();
    TextEditingController codigo = TextEditingController();
    TextEditingController cantidad = TextEditingController();
    nombreArticulo.text = widget.nombreArticuloP;
    tipoAticulo = widget.tipoArticuloP;
    descripcion.text = widget.descripcionP;
    precio.text = widget.precioP;
    codigo.text = widget.codigoP;
    cantidad.text = widget.cantidadP;

    final formkey = GlobalKey<FormState>();
    UrlImagen urlImagen = UrlImagen();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async{
            setState(() {
              imagen_to_upload = null;
              // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusquedaDeProductos()));
            });
          },
          icon: const Icon(Icons.arrow_back)
        ),
        title: const Text("Editar",style: TextStyle(color: Colors.white),),
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
                            backgroundImage: NetworkImage(widget.imagen),
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
                      controller: nombreArticulo,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Nombre del artículo',
                        labelText: 'Nombre del artículo',
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
                      keyboardType: TextInputType.name ,
                      decoration: const InputDecoration(
                        labelText: 'Descripcion',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Descripcion',
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
                //         labelText: 'Descripcion',
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
                        labelText: 'Precio',
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
                      controller: codigo,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Código',
                        labelText: 'Código',
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
                        labelText: 'Cantidad',
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
                        final upload = await urlImagen.subirImagen(imagen_to_upload!,tipoAticulo, nombreArticulo.text,"Aticulos",context);
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
                      if(imagen_to_upload == null){
                        await actualizardatos(widget.uid, nombreArticulo.text,tipoAticulo,descripcion.text,precio.text,codigo.text,cantidad.text,widget.imagen,context).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Articulo actualizado"),
                            backgroundColor: Color.fromARGB(255, 2, 118, 193),
                          )
                        );
                      });
                    }
                      else{
                      await actualizardatos(widget.uid, nombreArticulo.text,tipoAticulo,descripcion.text,precio.text,codigo.text,cantidad.text,urlImagen.url,context).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Artículo actualizado"),
                            backgroundColor: Color.fromARGB(255, 2, 118, 193),
                          )
                        );
                      });
                    }
                      setState(() {
                        imagen_to_upload == null;
                      });

                      nombreArticulo.clear();
                      // tipoAticulo.clear();
                      descripcion.clear();
                      precio.clear();
                      codigo.clear();
                      cantidad.clear();
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: Size(120, 50)),
                  child: const Text("Editar",style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,)),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}

