



// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List>getProductos(BuildContext context) async{

  showDialog(
    context: context,
    builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  );

  List productos = [];
  CollectionReference ref = db.collection("Productos");

  QuerySnapshot peticionProductos = await ref.get();

  for(var documento in peticionProductos.docs){
    productos.add(documento);
  }
  Navigator.of(context).pop();
  // pediticionProductos.docs.forEach((documento) {
  //   productos.add(documento);
  // }); 
  return productos;
}

Future<void> agregarProductos (String nombreArticulo, String tipoArticulo, String descripcion, String precio, String codigo, String cantidad,String imagen,BuildContext context) async{
   showDialog(
    context: context,
    builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  );
   await db.collection('Productos').add({
    "Nombre del articulo": nombreArticulo,
    "Tipo":tipoArticulo.trim(),
    "Descripcion":descripcion,
    "Precio":precio,
    "Codigo":codigo,
    "Cantidad":cantidad,
    "Imagen":imagen
   });
   
   Navigator.of(context).pop();
}


Future<void> actualizardatos(String uid, String nombreArticulo, String tipoArticulo, String descripcion, String precio, String codigo, String cantidad,String imagen ,BuildContext context) async{

  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    }
  );

  await db.collection('Productos').doc(uid).set({
    "Nombre del articulo":nombreArticulo,
    "Tipo":tipoArticulo.trim(),
    "Descripcion":descripcion,
    "Precio":precio,
    "Codigo":codigo,
    "Cantidad":cantidad,
    "Imagen":imagen
  });

  Navigator.of(context).pop();

}



Future<void> borrarDatos(String uid) async{

  await db.collection('Productos').doc(uid).delete();

}
