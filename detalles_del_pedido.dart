// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/pedidos/estado_del_pedido.dart';
import 'package:widgets_app/Presentation/pedidos/pedidos.dart';

class DetallesDelPedido extends StatefulWidget {
  final idPedidoUsuario;
  const DetallesDelPedido({super.key,required this.idPedidoUsuario});

  @override
  State<DetallesDelPedido> createState() => _DetallesDelPedidoState();
}

class _DetallesDelPedidoState extends State<DetallesDelPedido> {

  List documentosId = [];
  List searchResult = [];
  List resultList = [];

  final TextEditingController searchControler = TextEditingController();

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
    var data = await FirebaseFirestore.instance.collection('Pedidos').doc(widget.idPedidoUsuario).collection('Carritos de usuarios').orderBy('Nombre del articulo').get();

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
    buscarBaseDatos();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pedidos()));
          },
          icon: const Icon(Icons.arrow_back)
        ),
        title: CupertinoSearchTextField(
          itemColor: Colors.white,
          prefixIcon: const Icon(Icons.search,color: Colors.white,),
          controller: searchControler,
          style: const TextStyle(color: Colors.white),
          placeholderStyle: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
              itemCount: resultList.length,
              itemBuilder: (context,index){
                return Card(
                  color: const Color.fromARGB(255, 53, 133, 187),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre: ${resultList[index]['data']['Nombre del articulo']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Cantidad: ${resultList[index]['data']['Cantidad']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('N° Orden: ${resultList[index]['data']['Numero de orden']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Fecha: ${resultList[index]['data']['Fecha']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Precios: ${resultList[index]['data']['Precio']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,), 
                        Text('Estado del pedido: ${resultList[index]['data']['Estado del pedido']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                      ],
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.local_shipping,color: Colors.white,size: 30,),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EstadoDelPedido(idpedidosUsuarios: widget.idPedidoUsuario, idPedidosCarritosusuarios: resultList[index]['id'])));
                    },
                  ),
                );
              }
            ),
        
      
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}