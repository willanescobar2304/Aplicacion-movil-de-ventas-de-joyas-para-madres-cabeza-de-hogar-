
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> agregarPedidos(String nombreUsuario, String numeroDocumento, String idUsuarios, String nombreArticulo, String precio, String cantidad, String fecha, String numeroOrden, BuildContext context,String idDelArticulo,String direccionUsuario, String costoDelPedido, String numerocelularUsuario)async{
  try{
    // var cantidadDelArticulo;
    bool articuloRepetido = false;
    // showDialog(
    //   context: context,
    //   builder: (contex){
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }
    // );
      await db.collection('Pedidos').doc(idUsuarios).set({
      "Nombre del usuario": nombreUsuario,
      "Numero de documento": numeroDocumento,
      "Estado del pedido": "En camino",
      "Direccion de envio": direccionUsuario,
      "Costo del pedido": costoDelPedido, 
      "Numero de telefono": numerocelularUsuario
    });

    CollectionReference coleccion =  db.collection('Pedidos');
    DocumentReference documento = coleccion.doc(idUsuarios);
    CollectionReference refCarrito = documento.collection('Carritos de usuarios');
    QuerySnapshot carrito = await refCarrito.get();
    if(carrito.docs.isNotEmpty){
      for(var documentoCarrito in carrito.docs){
        if(documentoCarrito.get('Nombre del articulo')==nombreArticulo){
          // cantidadDelArticulo = documentoCarrito.get('Cantidad').toString();
          articuloRepetido = true;
        }
        // else if(documentoCarrito.id == idDelArticulo){
        //   print(documentoCarrito.id);
        // }
      }
      if(articuloRepetido == true){
        // int numero = int.parse(cantidadDelArticulo);
        // numero+=1;
        await db.collection('Pedidos').doc(idUsuarios).collection('Carritos de usuarios').doc(idDelArticulo).set({
          "Nombre del articulo":nombreArticulo,
          "Precio":precio.toString(),
          "Cantidad":cantidad,
          "Fecha":fecha,
          "Numero de orden":numeroOrden,
          "Estado del pedido":"En camino"
        });
      }
      else{
        await db.collection('Pedidos').doc(idUsuarios).collection('Carritos de usuarios').doc(idDelArticulo).set({
          "Nombre del articulo":nombreArticulo,
          "Precio":precio.toString(),
          "Cantidad":cantidad,
          "Fecha":fecha,
          "Numero de orden":numeroOrden,
          "Estado del pedido":"En camino"
        });
      }
    }
    else{ 
      await db.collection('Pedidos').doc(idUsuarios).collection('Carritos de usuarios').doc(idDelArticulo).set({
        "Nombre del articulo":nombreArticulo,
        "Precio":precio.toString(),
        "Cantidad":cantidad,
        "Fecha":fecha,
        "Numero de orden":numeroOrden,
        "Estado del pedido":"En camino"
      });
    }
    // ignore: use_build_context_synchronously
    //Navigator.of(context).pop();
  }catch(e){
    print("El error es:${e.toString()}");
  }
}

Future<void> borrarDocumentoCarritosUsuarios(String idDocumentoUsuarios, String idDocumentoArticulo)async{
  await db.collection('Pedidos').doc(idDocumentoUsuarios).collection('Carritos de usuarios').doc(idDocumentoArticulo).delete();
}

Future<String> solicitarpedido(String idUsuario, BuildContext context) async{
  showDialog(
    context: context,
  builder: (context){
    return const Center(child: CircularProgressIndicator(),);
  }
  );
  var estadoDelPedido;
  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference documentoref = db.collection('Pedidos').doc(idUsuario);
  DocumentSnapshot documentSnapshot = await documentoref.get();
  if(documentSnapshot.exists){
    estadoDelPedido = documentSnapshot.get('Estado del pedido');
  }
  else{
    estadoDelPedido = "Primer pedido";
  }
  // ignore: use_build_context_synchronously
  Navigator.pop(context);
  return estadoDelPedido;
}