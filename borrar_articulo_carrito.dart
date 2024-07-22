
import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> delete(String idDocumentoUsuario, String idDocumentoCarrito)async{
  await db.collection('Usuarios').doc(idDocumentoUsuario).collection('carrito').doc(idDocumentoCarrito).delete();
}