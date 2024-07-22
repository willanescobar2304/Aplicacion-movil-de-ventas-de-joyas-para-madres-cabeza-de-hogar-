import 'package:image_picker/image_picker.dart';



Future<XFile?> getImagen() async{
  
  final ImagePicker piker = ImagePicker();
  final XFile? imagen = await piker.pickImage(source: ImageSource.gallery);

  return imagen;
}


// class AgregarImagen{
//   File? imagen = null;
//   final picker = ImagePicker();

//   Future<void> selecionarImaden(val) async{
  
//   var pickedFile;

//   if(val == 1){
//     pickedFile = await picker.pickImage(source: ImageSource.camera);
//   }
//   else{
//     pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   }
//     if(pickedFile!=null){
//       imagen = File(pickedFile.path);
//       // cortarImagen(File(pickedFile.path));
//     }
//     else{

//     }
// }

//   imagenOpciones(BuildContext context) {
  
//   showDialog(
//     context: context,
//     builder: (BuildContext context){
//       return AlertDialog(
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: (){
//                   selecionarImaden(1);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     border:  Border(bottom: BorderSide(width: 1,color: Color.fromARGB(255, 160, 228, 255)))
//                   ),
//                   child: const Row(
//                     children: [
//                       Expanded(
//                         child: Text('Tomar una foto',style: TextStyle(fontSize: 20),), 
//                       ),
//                       Icon(Icons.camera_alt,color: Colors.black,)
//                     ],
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: (){
//                   selecionarImaden(2);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   child: const Row(
//                     children: [
//                       Expanded(
//                         child: Text('Cargar una foto',style: TextStyle(fontSize: 20),), 
//                       ),
//                       Icon(Icons.image,color: Colors.black,)
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     }
//   );
// }
// }