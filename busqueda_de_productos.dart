// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/editar.dart';
import 'package:widgets_app/Presentation/lista-funciones/lista_funciones.dart';
import 'package:widgets_app/services/firebase_services.dart';

class BusquedaDeProductos extends StatefulWidget {
  const BusquedaDeProductos({super.key});

  @override
  State<BusquedaDeProductos> createState() => _BusquedaDeProductosState();
}

class _BusquedaDeProductosState extends State<BusquedaDeProductos> {
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
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListaFunciones()));
          },
          icon: const Icon(Icons.arrow_back)
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
      body: resultList.isEmpty? const Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        itemCount: resultList.length,
        itemBuilder: (context,index){
          // var documentoMap = resultList[index];
          // var documentoId = documentoMap['id'];
          // var documentoData = documentoMap['data'];
          return ListTile(
            tileColor: Colors.white,
            title: Text(resultList[index]['data']['Nombre del articulo']),
            //subtitle: Text(resultList[index]['id']),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(resultList[index]['data']['Imagen']),
              ),
            ),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: const Text("Está seguro de eliminar este producto",textAlign: TextAlign.center,),
                          actions: [
                            TextButton(
                              onPressed: () async{
                                await borrarDatos(resultList[index]['id']);
                                resultList.removeAt(index);
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text("Si, estoy seguro de eliminar")
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar",style: TextStyle(color: Colors.red),textAlign: TextAlign.center,)
                            )
                          ],
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.delete)
                ),
                IconButton(
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> EditarArticulos(nombreArticuloP: resultList[index]['data']["Nombre del articulo"],tipoArticuloP: resultList[index]['data']['Tipo'],descripcionP: resultList[index]['data']['Descripcion'],precioP: resultList[index]['data']['Precio'],codigoP: resultList[index]['data']['Codigo'],cantidadP: resultList[index]['data']['Cantidad'],uid: resultList[index]['id'],imagen: resultList[index]['data']['Imagen'])));
                  },
                  icon: const Icon(Icons.edit)
                )
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}