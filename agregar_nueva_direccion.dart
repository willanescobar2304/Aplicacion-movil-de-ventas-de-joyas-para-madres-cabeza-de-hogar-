

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> agregarNuevaDireccion(String idUsuario, String nuevaDireccion, BuildContext context) async{
  showDialog(
    context: context,
    builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  );
  await db.collection('Usuarios').doc(idUsuario).update({
    "Direccion de recidencia":nuevaDireccion
  });
  Navigator.of(context).pop();
}