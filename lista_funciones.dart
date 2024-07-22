import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/agregar.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/busqueda_de_productos.dart';
import 'package:widgets_app/Presentation/lista-funciones/funciones/listar.dart';
import 'package:widgets_app/Presentation/logistica/logistica.dart';
// ignore: unused_import
import 'package:widgets_app/Presentation/screens/listadeproductos/lista_de_productos.dart';

class ListaFunciones extends StatelessWidget {
  const ListaFunciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Logistica()));
          },
          icon: const Icon(Icons.arrow_back)
        ),
        title: const Text("Agregar",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: Size(100, 100)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AgregarArticulo()));
              },
              child: const Text("Agregar",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
            ),
            trailing: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AgregarArticulo()));
              },
              icon: const Icon(Icons.chevron_right,size: 50,color: Color.fromARGB(255,2,118,193),)
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(100, 100)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusquedaDeProductos()));
              },
              child: const Text("Buscar Artículo",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
            ),
            trailing: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BusquedaDeProductos()));
              },
              icon: const Icon(Icons.chevron_right,size: 50,color: Color.fromARGB(255,2,118,193),)
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: Size(100, 100)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListarArticulos()));
              },
              child: const Text("Listar",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
            ),
            trailing: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListarArticulos()));
              },
              icon: const Icon(Icons.chevron_right,size: 50,color: Color.fromARGB(255,2,118,193),)
            ),
          ),
          
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}