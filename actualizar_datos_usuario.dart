
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
Future<void> actualizarDatosUsuario(String idDocumentousuario, String nombreusuario,String apellidoUsuario, String nombreDeUsuario, String numeroDeCedula, String numeroDeTelefono, String correoelectronico, String direccion, String imagenUsuario,BuildContext context) async{
  try{
    showDialog(
      context: context,
      builder: (context){
        return const Center(child: CircularProgressIndicator());
      }
    );
    await db.collection('Usuarios').doc(idDocumentousuario).update({
    'Nombre':nombreusuario,
    'Apellido':apellidoUsuario,
    'Nombre de usuario':nombreDeUsuario.trim(),
    'Numero de cedula':numeroDeCedula.trim(),
    'Numero de celular':numeroDeTelefono,
    'Correo electronico':correoelectronico,
    'Direccion de recidencia':direccion,
    'Imagen':imagenUsuario
  });
  Navigator.pop(context);
  }catch(e){
    print('el error es: '+e.toString());
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Error de conección'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Aceptar')
            )
          ],
        );
      }
    );
  }
}

Future<void> cambioClave(String idUsuario,String nuevaClave,BuildContext context) async{
  showDialog(
    context: context,
    builder: (context){
      return const Center(child: CircularProgressIndicator());
    }
  );
  await db.collection('Usuarios').doc(idUsuario).update({
    "Clave":nuevaClave.trim()
  });
  Navigator.pop(context);
}