
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> actualizarCantidadArticulo(String iudProducto, String cantidad) async{

  await db.collection('Productos').doc(iudProducto).update({
    "Cantidad":cantidad,
  });
}