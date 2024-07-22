

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


final FirebaseStorage storage = FirebaseStorage.instance;
class UrlImagen{
  late String url;


Future<bool> subirImagen(File image, String tipoArticulo, String nombreArticulo,String carpeta,BuildContext contex) async{
  
  // final String nombreImagen = image.path.split("/").last;
  
  showDialog(
    context: contex,
    builder: (contex){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  );

  Reference ref = storage.ref().child(carpeta).child(tipoArticulo.trim()).child(nombreArticulo);

  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  url = await snapshot.ref.getDownloadURL();
  

  print(url);
  
  
  if(snapshot.state == TaskState.success){
    Navigator.of(contex).pop();
    return true;
    
  }
  else{
    Navigator.of(contex).pop();
    return false;
  }

  
}
}