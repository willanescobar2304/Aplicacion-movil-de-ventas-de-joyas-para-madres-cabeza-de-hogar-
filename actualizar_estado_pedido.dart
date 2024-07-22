

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> actualizarEstadoDelPedido(String idUsuario, String idCarritosUsuarios, String estadoDelPedido,BuildContext context)async{
  
  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    }
  );
  
  await db.collection('Pedidos').doc(idUsuario).update({
    "Estado del pedido": estadoDelPedido
  });

  CollectionReference ref = db.collection('Pedidos').doc(idUsuario).collection('Carritos de usuarios');
  QuerySnapshot documento = await ref.get();
  
  documento.docs.forEach((DocumentSnapshot doc) async {
    var iddocumentocarrito = doc.id;

    await ref.doc(iddocumentocarrito).update({
      "Estado del pedido": estadoDelPedido
    });
  });
  Navigator.pop(context);
}