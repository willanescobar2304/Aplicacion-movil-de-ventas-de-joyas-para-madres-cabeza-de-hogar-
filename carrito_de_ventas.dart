// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> datosArticulos(String idArticulo) async{
  Map<String, dynamic> resultado = {};
  DocumentSnapshot documentoArticulos = await FirebaseFirestore.instance.collection('Productos').doc(idArticulo).get();
  
  if(documentoArticulos.exists){
    resultado['id'] = documentoArticulos.id;
    Map<String, dynamic> data = documentoArticulos.data() as Map<String, dynamic>;
    resultado['Cantidad'] = data['Cantidad'];
  }
   return resultado;
}

Future<void> carritodeVentas(String uid, String nombreArticulo, String cantidad, String idProducto,String precio, BuildContext context) async{
try{
  final DateFormat formatoPersonalizado = DateFormat("yyyy-MM-dd H:mm");
  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    }
  );

  var cantidadDelArticulo;
  bool idrepetido = false;
  CollectionReference coleccion = FirebaseFirestore.instance.collection('Usuarios');
  DocumentReference documento = coleccion.doc(uid);
  CollectionReference refcarrito = documento.collection('carrito');
  QuerySnapshot carrito = await refcarrito.get();
  if(carrito.docs.isNotEmpty){
    for(var documentocarrito in carrito.docs){
      if(documentocarrito.id == idProducto){
       cantidadDelArticulo = documentocarrito.get('Cantidad').toString();
        idrepetido = true;
      }
      else{
        //idrepetido = false;
      }
    }
    if(idrepetido == true){
      int numero = int.parse(cantidadDelArticulo);
      numero+=1;
      DateTime fechaActual = DateTime.now();
      String fecha = formatoPersonalizado.format(fechaActual);
      int numerodeorden = Random().nextInt(4000);
      await documento.collection('carrito').doc(idProducto).set({
        "Nombre del articulo":nombreArticulo,
        "Cantidad": numero.toString(),
        "Fecha": fecha,
        "Numero de orden": numerodeorden.toString(),
        "Precio":precio,
        "Estado del pedido": "En camino"
      });
    }
    else{
      cantidadDelArticulo ="1";
      DateTime fechaActual = DateTime.now();
      String fecha = formatoPersonalizado.format(fechaActual);
      int numerodeorden = Random().nextInt(4000);
      await documento.collection('carrito').doc(idProducto.toString()).set({
        "Nombre del articulo":nombreArticulo,
        "Cantidad": cantidadDelArticulo.toString(),
        "Fecha": fecha,
        "Numero de orden": numerodeorden.toString(),
        "Precio":precio,
        "Estado del pedido": "En camino"
      });
    }
  }
  else{
    cantidadDelArticulo = "1";
      DateTime fechaActual = DateTime.now();
      String fecha = formatoPersonalizado.format(fechaActual);
      int numerodeorden = Random().nextInt(4000);
      await documento.collection('carrito').doc(idProducto).set({
        "Nombre del articulo":nombreArticulo,
        "Cantidad": cantidadDelArticulo.toString(),
        "Fecha": fecha,
        "Numero de orden": numerodeorden.toString(),
        "Precio":precio,
        "Estado del pedido": "En camino"
      });
  }
  Navigator.pop(context);
}catch(e){
  Navigator.pop(context);
  showDialog(
    context: context,
    builder: (context){
      return const  AlertDialog(
        title: Text("¡UPS hubo un error, por favor cierra la aplicación y ábrela nuevamente!"),
      );
    }
  );
  //print("Error de Firebase corregir:${e.toString()}");
}
}
