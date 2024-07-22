import 'package:flutter/material.dart';
import 'package:widgets_app/Presentation/lista-funciones/lista_funciones.dart';
import 'package:widgets_app/Presentation/pedidos/pedidos.dart';
import 'package:widgets_app/Presentation/screens/home/home_screens.dart';

class Logistica extends StatelessWidget {
  const Logistica({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logística",style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(100, 100)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListaFunciones()));
              },
              child: const Text("Lista de artículos",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
            ),
            trailing: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListaFunciones()));
              },
              icon: const Icon(Icons.chevron_right,size: 50,color: Color.fromARGB(255,2,118,193),)
            ),
          ),
          ListTile(
            title: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),fixedSize: const Size(100, 100)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pedidos()));
              },
              child: const Text("Pedidos",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
            ),
            trailing: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pedidos()));
              },
              icon: const Icon(Icons.chevron_right,size: 50,color: Color.fromARGB(255,2,118,193),)
            ),
          ),
          const SizedBox(height: 20,),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 161, 186, 196),
                  image: DecorationImage(image: AssetImage("assets/imagenes/moon.png"))
                ),
              ),
            ),
          const SizedBox(height: 50,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193),textStyle: const TextStyle(fontSize: 20),fixedSize: Size(170, 50)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
              },
              child: const Text("Cerrar sesión",style: TextStyle(color: Colors.white),)
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}