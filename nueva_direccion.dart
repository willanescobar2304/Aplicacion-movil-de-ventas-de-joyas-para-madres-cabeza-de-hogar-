// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
import 'package:widgets_app/Presentation/nueva_direccion/agregar_nueva_direccion.dart';
// import 'package:widgets_app/Presentation/orden_detallada/pedidos_usuarios.dart';
// import 'package:widgets_app/Presentation/pedido_realizado/pedido_realizado.dart';
import 'package:widgets_app/Presentation/screens/home/home_screens.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';

class NuevaDireccion extends StatefulWidget {
  final String idUsuario;
  final String costoPedido;
  const NuevaDireccion({super.key, required this.idUsuario, required this.costoPedido});

  @override
  State<NuevaDireccion> createState() => _NuevaDireccionState();
}

class _NuevaDireccionState extends State<NuevaDireccion> {
  List documentosId = [];
  List searchResult = [];
  List resultList = [];
  String nombreUsuario = '';
  String documentoIdentidad = '';
  String direccionUsuario = '';
  String telefonousuario = '';

  final TextEditingController searchControler = TextEditingController();

  Future<void> datosUsuario()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference documentoref = db.collection('Usuarios').doc(widget.idUsuario);
    DocumentSnapshot documento = await documentoref.get();
    if(documento.exists){
      nombreUsuario = documento.get('Nombre');
      documentoIdentidad = documento.get('Numero de cedula');
      direccionUsuario = documento.get('Direccion de recidencia');
      telefonousuario = documento.get('Numero de celular');
    }
  }

  @override
  void initState(){
    searchControler.addListener(onSearchChange);
    super.initState();
  }

  onSearchChange(){
    print(searchControler.text);
    searchResultList();
  }
  

  searchResultList(){
    var showResult = [];
    if(searchControler.text.isNotEmpty){
      for(var clientSnapshot in searchResult){
        var name = clientSnapshot['data']['Nombre del articulo'].toString().toLowerCase();
        if(name.contains(searchControler.text.toLowerCase())){
          showResult.add(clientSnapshot);
        } 
      }
    }
    else{
      showResult = List.from(searchResult);
    }
    setState(() {
      resultList = showResult;
    });
  }

  datoscarrito()async{
    var data = await FirebaseFirestore.instance.collection('Usuarios').doc(widget.idUsuario).collection('carrito').orderBy('Nombre del articulo').get();
    List<Map<String,dynamic>>resultado = [];
    for(var documento in data.docs){
      var documentoID = documento.id;
      var documentoData = documento.data();
      var documentoMap = {
        'id':documentoID,
        'data':documentoData
      };
      resultado.add(documentoMap);
    }
    setState(() {
      searchResult = resultado;
    });
    searchResultList();
  }

  @override
  void dispose(){
    searchControler.removeListener(onSearchChange);
    searchControler.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    datosUsuario();
    datoscarrito();
    super.didChangeDependencies();
    
  }


  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    TextEditingController nuevaDireccion = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva dirección",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body:  SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: formkey,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Fondo(),
                )
                ),
            ),
            Column(
              children: [
              const Center(
                child:Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextoInicio(
                    horizontal: 10,
                    vertical: 10,
                    texto: "Por favor ingrese la nueva dirección",
                    fuente: 1.5,
                    alto: 95,
                    ancho: 290,
                    color: Color.fromARGB(255, 2, 118, 193),
                    fuenteColor: Colors.white,
                    colorBorde: Color.fromARGB(255, 2, 118, 193),
                    distancia: 30),
                ),
              ),
              Center(
                  child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Por favor ingrese un valor';
                      }
                      return null;
                    },
                    controller: nuevaDireccion,
                    keyboardType: TextInputType.name,
                    decoration:const  InputDecoration(
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: 'Nueva dirección',
                      hintStyle: TextStyle(color: Colors.black26),
                      filled: true,
                      fillColor: Colors.white,
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      )
                    ),
                  ),
                ),
              ),
              ),
      
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                   child: ElevatedButton(
                    onPressed: () async{
                      await agregarNuevaDireccion(widget.idUsuario, nuevaDireccion.text, context).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            actionOverflowThreshold: 1,
                            content: Text("La dirección fue modificada"),
                            backgroundColor: Color.fromARGB(255, 2, 118, 193),
                          )
                        );
                        nuevaDireccion.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                    child: const Text("Registrar dirección",style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                  ),
                 ),
                //  Padding(
                //    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 100),
                //    child: ElevatedButton(
                //     onPressed: () async{
                //      var estadoPedido = await solicitarpedido(widget.idUsuario, context);
                //      if(estadoPedido == "Primer pedido" || estadoPedido == "Pedido entregado"){
                //         for(var datos in resultList){
                //         await agregarPedidos(nombreUsuario, documentoIdentidad, widget.idUsuario, datos['data']['Nombre del articulo'], datos['data']['Precio'], datos['data']['Cantidad'], datos['data']['Fecha'], datos['data']['Numero de orden'],context,datos['id'],direccionUsuario,NumberFormat("#,###.###").format(widget.costoPedido.toString()),telefonousuario);
                //         }
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=> const PedidoRealizado()));
                //      }else{
                //       showDialog(
                //         context: context,
                //         builder: (context){
                //           return AlertDialog(
                //             title: const Text('Tienes pedidos pendientes por entregar, cuando sean entregados puedes solicitar más',textAlign: TextAlign.center,),
                //             actions: [
                //               ElevatedButton(
                //                 onPressed: (){
                //                   Navigator.pop(context);
                //                 },
                //                 style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                //                 child: const Text('Aceptar',style: TextStyle(color: Colors.white),)
                //               )
                //             ],
                //           );
                //         }
                //       );
                //      }
                //     },
                //     style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                //     child: const Text("Enviar pedido",style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                //   ),
                //  ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}