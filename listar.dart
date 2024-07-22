import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarArticulos extends StatefulWidget {
  const ListarArticulos({super.key});

  @override
  State<ListarArticulos> createState() => _ListarArticulosState();
}

class _ListarArticulosState extends State<ListarArticulos> {

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
    var data = await FirebaseFirestore.instance.collection('Productos').orderBy('Nombre del articulo').get();

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
        title: CupertinoSearchTextField(
          suffixIcon: const Icon(Icons.search,color: Colors.white,),
          prefixIcon: const Icon(Icons.search,color: Colors.white,),
          controller: searchControler,
          style: const TextStyle(color: Colors.white),
          placeholderStyle: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
      ),
      body:GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1,
          crossAxisSpacing: 2,
          childAspectRatio: 0.5,
        ),
        itemCount: resultList.length,
        itemBuilder: (contex,index){
          return  _listaDeArticulos(
              resultList[index]['data']['Nombre del articulo'], 
              resultList[index]['data']['Tipo'], 
              resultList[index]['data']['Precio'],
              resultList[index]['data']['Cantidad'],
              resultList[index]['data']['Imagen'],
              resultList[index]['data']['Codigo']
            );
        }
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}
Widget _listaDeArticulos(String nombre,String tipo,String precio, String cantidad, String imagen,String codigo){
return  Center(
  child: Card(
    color: const Color.fromARGB(255, 53, 133, 187),
    elevation: 5,
    child: SizedBox(
      width: 300,
      height: 600,
      child: Column(
        children:<Widget> [ 
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagen,fit: 
                BoxFit.cover
              ),
            )
          ),
          
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
            Text('Nombre: $nombre', style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
            const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
            Text('Tipo: $tipo', style: const TextStyle(color: Colors.white,fontSize: 15,)),
            const Padding(
            padding:EdgeInsets.all(3)),
            Text('Precio: $precio'.toString(),style: const TextStyle(color: Colors.white,fontSize: 15)),
            const Padding(padding:EdgeInsets.all(3)),
            Text('Cantidad: $cantidad'.toString(),style: const TextStyle(color: Colors.white,fontSize: 15)),
            const Padding(padding:EdgeInsets.all(3)),
            Text('Código: $codigo'.toString(),style: const TextStyle(color: Colors.white,fontSize: 15))
        ],
      ),
    ),
  ),
  );
}