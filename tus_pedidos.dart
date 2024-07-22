// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';
import 'package:widgets_app/Presentation/tus_pedidos/remover_historial_pedidos.dart';
class TusPedidos extends StatefulWidget {
  final String idDocumentoUsuario;
  const TusPedidos({super.key, required this.idDocumentoUsuario});

  @override
  State<TusPedidos> createState() => _TusPedidosState();
}

class _TusPedidosState extends State<TusPedidos> {

  List documentosId = [];
  List searchResult = [];
  List resultList = [];
  String estadoPedidoUsuario = '';
  double costoPedido = 0.0;

  final TextEditingController searchControler = TextEditingController();

  Future datospedido()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documento = await db.collection('Pedidos').doc(widget.idDocumentoUsuario).get();
    if(documento.exists){
     String costo = documento.get('Costo del pedido');
     estadoPedidoUsuario = documento.get('Estado del pedido');
     costoPedido = double.parse(costo);
    }
    else{
      costoPedido = 0.0;
    }
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
    var data = await FirebaseFirestore.instance.collection('Pedidos').doc(widget.idDocumentoUsuario).collection('Carritos de usuarios').orderBy('Nombre del articulo').get();
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
    datospedido();
    buscarBaseDatos();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          prefixIcon: const Icon(Icons.search,color: Colors.white,),
          controller: searchControler,
          style: const TextStyle(color: Colors.white),
          placeholderStyle: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: resultList.isEmpty? 
      Center(
        child: Column(
          children: [
            const SizedBox(
              width: 280,
              height: 200,
            child: Card(
              color: Color.fromARGB(255, 2, 118, 193),
              child: Center(
                child: Text('No tienes artículos pendientes',
                style: TextStyle(color: Colors.white,fontSize: 30),
                textAlign: TextAlign.center
              )),
            ),  
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Card(
                  child: Image.asset('assets/imagenes/vacio.png'),
                ),
              )
          ),
          
          ],
        ),
      )
      :Column(
        children: [
          const TextoInicio(
            horizontal: 10,
            vertical: 20,
            texto: "Costo total del pedido",
            fuente: 1.5,
            alto: 80,
            ancho: 250,
            color: Color.fromARGB(255, 2, 118, 193),
            fuenteColor: Colors.white,
            colorBorde: Color.fromARGB(255, 2, 118, 193),
            distancia: 5
          ),
          TextoInicio(
            horizontal: 10,
            vertical: 20,
            texto: estadoPedidoUsuario == "Pedido entregado"
            ? NumberFormat("#,###.###").format(costoPedido=0.0)
            :NumberFormat("#,###.###").format(costoPedido),
            fuente: 1.5,
            alto: 80,
            ancho: 250,
            color: Colors.white,
            fuenteColor: Colors.black,
            colorBorde: const Color.fromARGB(255, 2, 118, 193),
            distancia: 5
          )
          ,Expanded(
            child: ListView.builder(
              itemCount: resultList.length,
              itemBuilder: (context,index){
                return ListTile(
                  tileColor: const Color.fromARGB(255, 223, 246, 255),
                  title:Center(
                    child: SizedBox(
                      width: 200,
                      height: 250,
                      child: Card(
                        color: const Color.fromARGB(255, 53, 133, 187),
                        child: Column(
                          children: [
                            const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
                            Text("Nombre: ${resultList[index]['data']['Nombre del articulo']}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
                            const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
                            Text("Cantidad: ${resultList[index]['data']['Cantidad']}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
                            const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
                            Text("Fecha: ${resultList[index]['data']['Fecha']}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
                            const Padding(
                            padding:EdgeInsets.all(3)),
                            Text("N° Orden: ${resultList[index]['data']['Numero de orden']}",style: const TextStyle(color: Colors.white,fontSize: 15), textAlign: TextAlign.center,),
                            const Padding(
                            padding:EdgeInsets.all(3)),
                            Text("Estado del pedido: ${resultList[index]['data']['Estado del pedido']}",style: const TextStyle(color: Colors.white,fontSize: 15), textAlign: TextAlign.center,),
                            Center(
                              child: IconButton(
                                onPressed:(){
                                    showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: const Text('Estás seguro de eliminar este pedido, que ya fue entregado'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: ()async{
                                                var estadoPedido = await revisarestadodelpedido(widget.idDocumentoUsuario,context,resultList[index]['id']);
                                                if(estadoPedido == "Pedido entregado"){
                                                await eliminarPedidosUsuarios(widget.idDocumentoUsuario,resultList[index]['id']);  
                                                setState(() {
                                                resultList.removeAt(index);
                                                Navigator.pop(context);  
                                                });                                                                     
                                                }
                                                else{
                                                  showDialog(
                                                    context: context,
                                                    builder: (context){
                                                      return const AlertDialog(
                                                        title: Text('El Pedido no ha sido entregado'),
                                                      );
                                                    }
                                                  );
          
                                                  //Navigator.pop(context);
                                                }
                                                //Navigator.pop(context);                                
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                                            child: const Text('Aceptar',style: TextStyle(color: Colors.white),)
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                                            child: const Text('Cancelar',style: TextStyle(color: Colors.white),)
                                          )
                                        ],
                                      );
                                    }
                                  );                            
                                },
                                icon: const Icon(Icons.delete_forever_rounded,color: Colors.white,)
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                );
              },
            ),
          ),
        ],
      ),
        backgroundColor: const Color.fromARGB(255, 223, 245, 255),
      );
  }
}
