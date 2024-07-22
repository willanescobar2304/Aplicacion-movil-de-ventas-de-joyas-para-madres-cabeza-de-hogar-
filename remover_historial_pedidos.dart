
// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<String> revisarestadodelpedido(String idUsuario,BuildContext context,String idProducto) async{
  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    }
  );
  var estadodelPedido;
  DocumentSnapshot pedios = await db.collection('Pedidos').doc(idUsuario).collection('Carritos de usuarios').doc(idProducto).get();
  if(pedios.exists){
    estadodelPedido = pedios.get('Estado del pedido');
  }
  Navigator.pop(context);
  return estadodelPedido;
}
Future<void> eliminarPedidosUsuarios(String idUsuario, String idproducto)async{
  db.collection('Pedidos').doc(idUsuario).collection('Carritos de usuarios').doc(idproducto).delete();
}