// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/Detalles_producto/carrito_de_ventas.dart';
import 'package:widgets_app/Presentation/Detalles_producto/imagen_detallada.dart';
import 'package:widgets_app/Presentation/orden_detallada/orden_detallada.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';
import 'package:widgets_app/Presentation/screens/listadeproductos/lista_de_productos.dart';

import '../orden_detallada/actualizar_cantidad_articulo.dart';


class DetalleProducto extends StatefulWidget {
  final String nombre;
  final String precio;
  String cantidad;
  final String descripcion;
  final String imagen;
  final String documentoID;
  final String idProducto;
  final String nombreUsuario;
  final String correoUsuario;
  final String imagenUsuario;
  DetalleProducto({super.key, required this.nombre, required this.precio, required this.cantidad, required this.descripcion, required this.imagen, required this.documentoID, required this.idProducto, required this.nombreUsuario, required this.correoUsuario, required this.imagenUsuario});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  var idArticuloLeido;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            setState(() {
              widget.cantidad;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ListaDeProductos(imagenUsuario: widget.imagenUsuario, nombreUsuarioAvatar: widget.nombreUsuario, correoUsuarioAvatar: widget.correoUsuario, documentoID: widget.documentoID)));
          },
          icon: const Icon(Icons.arrow_back)
        ),
        title: const Text("Detalles del artículo"),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body:  SingleChildScrollView(
        child:Column(
          children: [
            Center(
              child: TextoInicio(
                alto: 60,
                ancho: 300,
                color: const Color.fromARGB(255, 2, 118, 193),
                colorBorde: const Color.fromARGB(255, 2, 118, 193),
                distancia: 20,
                fuente: 1.2,
                fuenteColor: Colors.white,
                horizontal: 70,
                texto: widget.nombre,
                vertical: 15,),
            ),
           SizedBox(
                width: 250,
                height: 370,
               child:Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  color: const Color.fromARGB(255, 53, 133, 187),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagenAmpliada(nombreArticulo: widget.nombre, imagen: widget.imagen)));
                        },
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(widget.imagen,fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text("Nombre: ${widget.nombre}",style: const TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text("Precio: ${widget.precio}",style: const TextStyle(color: Colors.white),textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text("Cantidad: ${widget.cantidad}",style: const TextStyle(color: Colors.white),textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text("Descripción: ${widget.descripcion}",style: const TextStyle(color: Colors.white),textAlign: TextAlign.center),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: ()async{
                  
                  Map<String,dynamic> resultado = await datosArticulos(widget.idProducto);
                  var cantidadArticulo = resultado['Cantidad'];
                  idArticuloLeido = resultado['id'];
                  int valorCntidad = int.parse(cantidadArticulo);

                  if(valorCntidad > 0){
                      int numeroCantidad = int.parse(cantidadArticulo);
                      numeroCantidad-=1;
                      await actualizarCantidadArticulo(idArticuloLeido, numeroCantidad.toString()).then((value){
                        setState(() {
                        widget.cantidad;
                      });
                      });
                      await carritodeVentas(widget.documentoID, widget.nombre, widget.cantidad, widget.idProducto,widget.precio, context).then((value){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Producto agregado al carrito", style: TextStyle(color: Colors.white),),
                          backgroundColor: Color.fromARGB(255, 2, 118, 193),
                        )
                      );
                    });
                    // setState(() {
                    //   widget.cantidad = numeroCantidad.toString();
                    // });
                  }else{
                    showDialog(
                      context: context,
                      builder: (context){
                        return const AlertDialog(
                          title: Text('¡UPS, este artículo no se encuentra disponible!',style: TextStyle(color: Colors.white),),
                          backgroundColor: Color.fromARGB(255, 53, 133, 187),
                        );
                      }
                    );
                  }                                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size.fromHeight(50),),
                child: const Text("Agregar al carrito",style: TextStyle(color: Colors.white),),
                ),
              const SizedBox(height: 10,),
              Wrap(
                children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaDeProductos(imagenUsuario: widget.imagenUsuario,nombreUsuarioAvatar: widget.nombreUsuario,correoUsuarioAvatar: widget.correoUsuario,documentoID: widget.documentoID,)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(125,50)),
                child: const Text("Seguir pidiendo",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
            const SizedBox(width: 15),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> OrdenDetallada(iud: widget.documentoID)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(125,50)),
                child: const Text("Ver orden detallada",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
                ],
              )
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}