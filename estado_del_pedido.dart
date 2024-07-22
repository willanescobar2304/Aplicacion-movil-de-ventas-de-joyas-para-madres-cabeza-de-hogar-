import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/pedidos/actualizar_estado_pedido.dart';

class EstadoDelPedido extends StatefulWidget {
  final String idpedidosUsuarios;
  final String idPedidosCarritosusuarios;
  const EstadoDelPedido({super.key, required this.idpedidosUsuarios, required this.idPedidosCarritosusuarios});

  @override
  State<EstadoDelPedido> createState() => _EstadoDelPedidoState();
}

class _EstadoDelPedidoState extends State<EstadoDelPedido> {
  bool estadoImagen1 = false;
  bool estadoImagen2 = false;
  bool estadoImagen3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estado del pedido",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100,),
              Card(
                color: const Color.fromARGB(255, 53, 133, 187),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pedido entregado',style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.start,)
                    ],
                  ),
                  onTap: ()async{
                    setState(() {
                      estadoImagen1 = true;
                    });
                    await actualizarEstadoDelPedido(widget.idpedidosUsuarios, widget.idPedidosCarritosusuarios, "Pedido entregado",context).then((value){    
                      showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: const Text('El pedido ha sido entregado'),
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
                  },
                  trailing: estadoImagen1 == true
                  ? Image.asset('assets/imagenes/Pedidoentregado.png') 
                  :const Icon(Icons.pending,color: Colors.white,size: 50,)
                  //const Icon(Icons.check,color: Colors.white,size: 50,),
                ),
              ),
              const SizedBox(height: 100,),
              Card(
                color: const Color.fromARGB(255, 53, 133, 187),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Devolución del pedido',style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.start,)
                    ],
                  ),
                  onTap: ()async{
                    setState(() {
                      estadoImagen2 = true;
                    });
                    await actualizarEstadoDelPedido(widget.idpedidosUsuarios, widget.idPedidosCarritosusuarios, "Devolucion del pedido",context).then((value){
                      showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: const Text('El pedido fue devuelto'),
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
                  },
                  trailing: estadoImagen2 == true 
                  ? Image.asset('assets/imagenes/Devolucionpedido.png')
                  :const Icon(Icons.pending,color: Colors.white,size: 50,),
                ),
              ),
              const SizedBox(height: 100,),
              Card(
                color: const Color.fromARGB(255, 53, 133, 187),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pedido cancelado',style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.start,)
                    ],
                  ),
                  onTap: ()async{
                    setState(() {
                      estadoImagen3 = true;
                    });
                    await actualizarEstadoDelPedido(widget.idpedidosUsuarios, widget.idPedidosCarritosusuarios, "Pedido Cancelado",context).then((value){
                      showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: const Text('El pedido ha sido cancelado'),
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
                  },
                  trailing: estadoImagen3 == true
                  ?Image.asset('assets/imagenes/Pedidocancelado.png')
                  :const Icon(Icons.pending, color: Colors.white,size: 50,)
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}