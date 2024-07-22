// ignore_for_file: unused_import, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgets_app/Presentation/Detalles_producto/detalles_producto.dart';
import 'package:widgets_app/Presentation/nueva_direccion/nueva_direccion.dart';
import 'package:widgets_app/Presentation/orden_detallada/actualizar_cantidad_articulo.dart';
import 'package:widgets_app/Presentation/orden_detallada/borrar_articulo_carrito.dart';
import 'package:widgets_app/Presentation/orden_detallada/pedidos_usuarios.dart';
import 'package:widgets_app/Presentation/pedido_realizado/pedido_realizado.dart';
import 'package:widgets_app/Presentation/screens/home/home_screens.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';

import '../Detalles_producto/carrito_de_ventas.dart';

// ignore: must_be_immutable
class OrdenDetallada extends StatefulWidget {
  final String iud;
  // final String cantidadArticuloDisponible;
  // final String idDelarticulo;
  const OrdenDetallada({super.key, required this.iud});

  @override
  State<OrdenDetallada> createState() => _OrdenDetalladaState();
}

class _OrdenDetalladaState extends State<OrdenDetallada> {
  List<OrdenDetallada>ordens = List.empty(growable: true);
  List documentosId = [];
  List searchResult = [];
  List resultList = [];
  double precioTotal = 0.0;
  double comision = 0.0;
  String nombreUsuario = '';
  String documentoIdentidad = '';
  String idBorrarPedido = '';
  String direccionUsuario = '';
  String numeroDeTelefonoUsuario = '';
  bool confirmarpedido = false;

  final TextEditingController searchControler = TextEditingController();

  Future<void> datosUsuario()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference documentoref = db.collection('Usuarios').doc(widget.iud);
    DocumentSnapshot documento = await documentoref.get();
    if(documento.exists){
      nombreUsuario = documento.get('Nombre');
      documentoIdentidad = documento.get('Numero de cedula');
      direccionUsuario = documento.get('Direccion de recidencia');
      numeroDeTelefonoUsuario = documento.get('Numero de celular');
    }
  }

  Future<void> valoresNumericos()async{
    var data = await FirebaseFirestore.instance.collection('Usuarios').doc(widget.iud).collection('carrito').orderBy('Nombre del articulo').get();
    for(var documento in data.docs){
      if(documento.get('Cantidad')!="1"){
        String precioString = documento.get('Precio');
        String cantidadString = documento.get('Cantidad');
        int cantidadInt = int.parse(cantidadString);
        double precioDouble = double.parse(precioString.replaceAll(',', ''));
        precioTotal += precioDouble*cantidadInt;
        
      }
      else{
        String precioString = documento.get('Precio');
        double precioDouble = double.parse(precioString.replaceAll(',', ''));
        precioTotal += precioDouble;
      }
    }
    setState(() {
    comision = precioTotal*0.15;
    precioTotal = precioTotal-comision;  
    });
    
  }
  

  @override
  void initState(){
    searchControler.addListener(onSearchChange);
    super.initState();
  }

  onSearchChange(){
    print(searchControler.text);
    searchResultList();
  }
  

  searchResultList(){
    var showResult = [];
    if(searchControler.text.isNotEmpty){
      for(var clientSnapshot in searchResult){
        var name = clientSnapshot['data']['Nombre del articulo'].toString().toLowerCase();
        if(name.contains(searchControler.text.toLowerCase())){
          showResult.add(clientSnapshot);
        } 
      }
    }
    else{
      showResult = List.from(searchResult);
    }
    setState(() {
      resultList = showResult;
    });
  }
  

  buscarBaseDatos() async{

    var data = await FirebaseFirestore.instance.collection('Usuarios').doc(widget.iud).collection('carrito').orderBy('Nombre del articulo').get();
    List<Map<String, dynamic>> resultado = [];

    for(var documento in data.docs){

      var documentoID = documento.id;
      var documentoData = documento.data();
      var documentoMap = {
        'id':documentoID,
        'data':documentoData
      };
      resultado.add(documentoMap);
    }
    setState(() {
      searchResult= resultado;
    });
    searchResultList();
  }

  @override
  void dispose(){
    searchControler.removeListener(onSearchChange);
    searchControler.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    datosUsuario();
    valoresNumericos();
    buscarBaseDatos();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            setState(() {
            Navigator.pop(context);  
            });
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,)
        ),
        title: CupertinoSearchTextField(
          prefixIcon: const Icon(Icons.search,color: Colors.white,),
          controller: searchControler,
          style: const TextStyle(color: Colors.white),
          placeholderStyle: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            height: 800,
            color: const Color.fromARGB(255, 223, 246, 255),
            child:  Column(
            children: [
              const TextoInicio(
                      alto: 50,
                      ancho: 250,
                      color: Color.fromARGB(255, 2, 118, 193),
                      colorBorde: Color.fromARGB(255, 2, 118, 193),
                      distancia: 20,
                      fuente: 1.5,
                      fuenteColor: Colors.white,
                      horizontal: 10,
                      texto: 'Total a pagar',
                      vertical: 10,),
              TextoInicio(
                    alto: 100,
                    ancho: 250,
                    color: Colors.white,
                    colorBorde: const Color.fromARGB(255, 2, 118, 193),
                    distancia: 10,
                    fuente: 2,
                    fuenteColor: Colors.black,
                    horizontal: 20,
                    texto: resultList.isEmpty ?  "0"
                    :NumberFormat("#,###.###").format(precioTotal),
                    vertical: 20,),
              const SizedBox(height: 10,),
              Expanded(
                child: resultList.isEmpty ? const TextoInicio(horizontal: 20, vertical: 20, texto: "Por favor agrega productos al carrito, y recuerda que solo puedes hacer un pedido, una vez recibas el pedido puedes volver a solictar artículos.", fuente: 1.3, alto: 250, ancho: 250, color: Color.fromARGB(255, 53, 133, 187), fuenteColor: Colors.white, colorBorde: Colors.white, distancia: 1)
                :GridView.builder(
                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 0.5,
                        childAspectRatio: 0.7,
                      ), 
                      shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: resultList.length,
                      itemBuilder: (context,index)=>getRow(resultList[index]['data']['Nombre del articulo'],resultList[index]['data']['Cantidad'],resultList[index]['data']['Fecha'],resultList[index]['data']['Numero de orden'],resultList[index]['data']['Precio'],resultList[index]['id'],widget.iud, index),
                    ),
                  
              ),
                const TextoInicio(
                    horizontal: 10,
                    vertical: 15,
                    texto: "Total comisión",
                    fuente: 1.5,
                    alto: 70,
                    ancho: 200,
                    color: Color.fromARGB(255, 2, 118, 193),
                    fuenteColor: Colors.white,
                    colorBorde: Color.fromARGB(255, 2, 118, 193),
                    distancia: 5),
                TextoInicio(
                    horizontal: 10,
                    vertical: 15,
                    texto: resultList.isEmpty ? "0"
                    :NumberFormat("#,###.###").format(comision),
                    fuente: 1.5,
                    alto: 70,
                    ancho: 200,
                    color: Colors.white,
                    fuenteColor: Colors.black,
                    colorBorde: const Color.fromARGB(255, 2, 118, 193),
                    distancia: 20),
                const SizedBox(height: 20),
                 Wrap(
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: (){
                        if(resultList.isEmpty){
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text('No tienes artículos agregados a tu carrito, por favor agrega artículos.'),
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
                        }
                        else{
                          String precitotalToString = NumberFormat("#,###.###").format(precioTotal).toString(); 
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NuevaDireccion(idUsuario: widget.iud,costoPedido: precitotalToString,)));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                      child: const Text("Otra dirección",style: TextStyle(color: Colors.white),),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      onPressed: ()async{
                        // int numero = 0;
                        if(resultList.isEmpty){
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text('No tienes artículos agregados a tu carrito, por favor agrega artículos.'),
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
                        }
                        else{
                        var estadoDelPedido = await solicitarpedido(widget.iud,context);

                        if(estadoDelPedido == "Primer pedido" || estadoDelPedido == "Pedido entregado"){
                          showDialog(
                            context: context,
                            builder: (context){
                              return const Center(child: CircularProgressIndicator(),);
                            }
                          );
                          for(var datos in resultList){
                            //Map<String,dynamic> resultado = await datosArticulos(datos['id']);
                            // var cantidadArticulo = resultado['Cantidad'];
                            // int numeroCantiad = int.parse(cantidadArticulo);
                            // int numeroCantidadcarrito = int.parse(datos['data']['Cantidad']);

                            // numeroCantiad-=numeroCantidadcarrito;

                            //await actualizarCantidadArticulo(datos['id'],numeroCantiad.toString());
                            await agregarPedidos(nombreUsuario, documentoIdentidad, widget.iud, datos['data']['Nombre del articulo'], datos['data']['Precio'], datos['data']['Cantidad'], datos['data']['Fecha'], datos['data']['Numero de orden'],context,datos['id'],direccionUsuario,precioTotal.toString(),numeroDeTelefonoUsuario);      
                            await delete(widget.iud,datos['id']);
                            // resultList.removeAt(numero);
                            // numero+=1;           
                          }
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PedidoRealizado()));
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text('Tienes pedidos pendientes por entregar, cuando sean entregados puedes solicitar más',textAlign: TextAlign.center,),
                                actions: [
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                                    child: const Text("Aceptar",style: TextStyle(color: Colors.white),)
                                  )
                                ],
                              );
                            }
                          );
                        }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                      child: const Text("Realizar pedido",style: TextStyle(color: Colors.white),),
                      ),
                  )
                  ],
                ),
                const SizedBox(height: 20,)
            ],
          ),
          )
        ),
      )
    );
  }

  Widget getRow(String nombre, String cantidad, String fecha, String numeroDeOrden, String precio, String idArticuloAgregado, String idDocumentoUsuario, int index){
    return Center(
    // ignore: unrelated_type_equality_checks
    child: Card(
      color: const Color.fromARGB(255, 53, 133, 187),
      elevation: 5,
      child: SizedBox(
        width: 200,
        height: 500,
        child: Column(
          children:<Widget> [ 
            const SizedBox(height: 5,),
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
              Text("Nombre: ${nombre}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
              Text("Precio: ${precio}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
              Text("Cantidad: ${cantidad}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center),
              const Padding(
              padding:EdgeInsets.all(3)),
              Text("Fecha: ${fecha}",style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center),
              const Padding(
              padding:EdgeInsets.all(3)),
              Text("N° Orden: ${numeroDeOrden}",style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center),
              Center(
                child: IconButton(
                  onPressed:() async{
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 53, 133, 187),
                          title: const Text('Estas seguro de borrar el artículo del carrito',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                          actions: [
                            ElevatedButton(
                              onPressed: () async{                                
                                await delete(idDocumentoUsuario,idArticuloAgregado);      
                                resultList.removeAt(index);
                                Map<String,dynamic> resultado = await datosArticulos(idArticuloAgregado);
                                var cantidadArticulo = resultado['Cantidad'];
                                var idArticuloLeido = resultado['id'];
                                int numeroCantidad = int.parse(cantidadArticulo);
                                int cantidadArticuloSolicitado = int.parse(cantidad);
                                numeroCantidad+=cantidadArticuloSolicitado;
                                await actualizarCantidadArticulo(idArticuloLeido, numeroCantidad.toString()).then((value){
                                  Navigator.pop(context);
                                });
                                await borrarDocumentoCarritosUsuarios(idDocumentoUsuario, idArticuloLeido).then((value){
                                  //Navigator.of(context).pop();
                                });
                                //Navigator.pop(context);
                                setState(() {
                                  comision = precioTotal*0.15;
                                  precioTotal = precioTotal-comision;
                                  
                                });
                                
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 223, 246, 255)),
                              child: const Text('Aceptar',style: TextStyle(color: Color.fromARGB(255, 2, 118, 193)),)
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 223, 246, 255)),
                              child: const Text('Cancelar',style: TextStyle(color: Color.fromARGB(255, 2, 118, 193)),)
                            )
                          ],
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.delete,color: Colors.white,)
                ),
              )
          ],
        ),
      ),
    ),
  );
  }
}

class DetallesOrden{
  DetallesOrden({
    required this.nombre,
    required this.cantidad,
    required this.fecha,
    required this.numeroOrden
    });
  String nombre;
  int cantidad;
  String fecha;
  int numeroOrden;
}