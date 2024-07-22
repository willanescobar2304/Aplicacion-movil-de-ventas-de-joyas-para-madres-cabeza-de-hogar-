

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgets_app/Presentation/logistica/logistica.dart';
import 'package:widgets_app/Presentation/pedidos/detalles_del_pedido.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {

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
    var data = await FirebaseFirestore.instance.collection('Pedidos').orderBy('Nombre del usuario').get();

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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const Logistica()));
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
                        Text('Usuario: ${resultList[index]['data']['Nombre del usuario']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Documento: ${resultList[index]['data']['Numero de documento']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Costo: ${convertirCosto(resultList[index]['data']['Costo del pedido'])}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Envio: ${resultList[index]['data']['Direccion de envio']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Teléfono: ${resultList[index]['data']['Numero de telefono']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                        Text('Estado del pedido: ${resultList[index]['data']['Estado del pedido']}',style: const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.start,),
                      ],
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.info_outline_rounded,color: Colors.white,size: 30,),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DetallesDelPedido(idPedidoUsuario: resultList[index]['id'])));
                    },
                  ),
                );
              }
            ),
        
      
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }

}

String convertirCosto(String costo) {

  var costocomoCadena = costo;
  double costocomoNumero = double.parse(costocomoCadena);
  var costoFormateado = NumberFormat("#,###.###").format(costocomoNumero);
  return costoFormateado;
}