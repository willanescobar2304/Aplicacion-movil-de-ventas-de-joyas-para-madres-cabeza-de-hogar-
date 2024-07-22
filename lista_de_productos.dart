//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/orden_detallada/orden_detallada.dart';
import 'package:widgets_app/Presentation/screens/edicion_de_usuario/editar_datos_usuario.dart';
import 'package:widgets_app/Presentation/screens/home/home_screens.dart';
import 'package:widgets_app/Presentation/tus_pedidos/tus_pedidos.dart';

import '../../Detalles_producto/detalles_producto.dart';

class ListaDeProductos extends StatefulWidget {
  

  static const String name = 'buttons';
  final String imagenUsuario;
  final String nombreUsuarioAvatar;
  final String correoUsuarioAvatar;
  final String documentoID;

  const ListaDeProductos({super.key, required this.imagenUsuario, required this.nombreUsuarioAvatar, required this.correoUsuarioAvatar, required this.documentoID});

  @override
  State<ListaDeProductos> createState() => _ListaDeProductosState();
}
class _ListaDeProductosState extends State<ListaDeProductos> {

    
  List documentosId = [];
  List searchResult = [];
  List resultList = [];

  final TextEditingController searchControler = TextEditingController();

  @override
  void initState(){
    searchControler.addListener(onSearchChange);
    buscarBaseDatos();
    super.initState();
  }

  @override
  void didUpdateWidget(ListaDeProductos oldWidget) {
    super.didUpdateWidget(oldWidget);
    // La pantalla está siendo reconstruida, por lo que se llama a buscarBaseDatos nuevamente.
    buscarBaseDatos();
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
  

 Future<void> buscarBaseDatos() async{
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
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
      drawer:Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              // ignore: sort_child_properties_last
              padding: const EdgeInsets.symmetric(horizontal: 15,),
              // ignore: sort_child_properties_last
              child: UserAccountsDrawerHeader(
                margin: const EdgeInsets.all(3),
                  accountName: Text(widget.nombreUsuarioAvatar),
                  accountEmail: Text(widget.correoUsuarioAvatar),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(widget.imagenUsuario),
                  ),
                  ),
                decoration: const BoxDecoration(
                color:  Color.fromARGB(255, 2, 118, 193)
              ),
              
            ),
            ListTile(
              title: const Text("Orden detallada"),
              trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdenDetallada(iud: widget.documentoID)));
                  setState(() {
                    resultList;
                  });                
                },
            ),
            ListTile(
              title: const Text("Tus pedidos pendientes"),
              trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TusPedidos(idDocumentoUsuario: widget.documentoID)));
                },
            ),
            ListTile(
              title: const Text("Editar datos personales"),
              trailing: const Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarDadosDelUsuario(idDocumentoUsuario: widget.documentoID,)));
                },
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
              onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));
                                  
              },
              child: const Text("Cerrar sesión",style: TextStyle(color: Colors.white),),
              )
          ],
        ),
      ),
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
    body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 2,
            childAspectRatio: 0.6,
          ),
          itemCount: resultList.length,
          itemBuilder: (context,index){
            return Center(
  child: Center(
    child: Card(
      color: Color.fromARGB(255, 187, 53, 53),
      elevation: 5,
      child: SizedBox(
        width: 200,
        height: 500,
        child: Column(
          children:<Widget> [ 
            const SizedBox(height: 5,),
            InkWell(
              onTap: (){
                setState(() {
                  resultList[index]['data']['Cantidad'];
                });
                Navigator.push(context,MaterialPageRoute(builder: (context)=>DetalleProducto(nombre: resultList[index]['data']['Nombre del articulo'], precio: resultList[index]['data']['Precio'], cantidad: resultList[index]['data']['Cantidad'], descripcion: resultList[index]['data']['Descripcion'], imagen: resultList[index]['data']['Imagen'],documentoID: widget.documentoID,idProducto: resultList[index]['id'],nombreUsuario: widget.nombreUsuarioAvatar,correoUsuario: widget.correoUsuarioAvatar,imagenUsuario: widget.imagenUsuario,)));
              },
              child: SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(resultList[index]['data']['Imagen'],
                  fit:  BoxFit.cover)
                )
              ),
            ),
            
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
              Text("Nombre: ${resultList[index]['data']['Nombre del articulo']}", style: const TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1)),
              Text("Precio: ${resultList[index]['data']['Precio']}", style: const TextStyle(color: Colors.white,fontSize: 15)),
              const Padding(
              padding:EdgeInsets.all(3)),
              Text("Cantidad: ${resultList[index]['data']['Cantidad']}",style: const TextStyle(color: Colors.white,fontSize: 15)),
          ],
        ),
      ),
    ),
  ),
  );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 174, 230, 253),
      ),
    );           
  }
}




