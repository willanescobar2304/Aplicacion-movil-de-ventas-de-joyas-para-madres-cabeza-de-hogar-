import 'package:flutter/material.dart';
//import 'package:widgets_app/Presentation/screens/listadeproductos/lista_de_productos.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';

class PedidoRealizado extends StatefulWidget {
  const PedidoRealizado({super.key});

  @override
  State<PedidoRealizado> createState() => _PedidoRealizadoState();
}

class _PedidoRealizadoState extends State<PedidoRealizado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)
          ),
        title: const Text("Pedido realizado",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body:  SingleChildScrollView(
        child: Center(
              child: Column(
              children: [
                const Center(
                  child: TextoInicio(
                    horizontal: 5,
                    vertical: 30,
                    texto: "¡Gracias por realizar tu pedido!",
                    fuente: 2.5,
                    alto: 200,
                    ancho: 310,
                    color: Color.fromARGB(255, 2, 118, 193),
                    fuenteColor:Colors.white,
                    colorBorde: Color.fromARGB(255, 2, 118, 193),
                    distancia: 20
                  ),
                ),
                const Center(
                  child: TextoInicio(
                    horizontal: 10,
                    vertical: 20,
                    texto: "Tu pedido está en camino",
                    fuente: 1.5,
                    alto: 100,
                    ancho: 200,
                    color: Color.fromARGB(255, 2, 118, 193),
                    fuenteColor: Colors.white,
                    colorBorde: Color.fromARGB(255, 2, 118, 193),
                    distancia: 50
                    ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 250,
                  child: Image.asset("assets/imagenes/scooter.gif"),
                )
              ],
            ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}

