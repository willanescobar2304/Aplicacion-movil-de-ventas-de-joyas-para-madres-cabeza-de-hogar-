//import 'dart:html';

// ignore_for_file: use_build_context_synchronously

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_app/Presentation/logistica/logistica.dart';
import 'package:widgets_app/Presentation/screens/registro_de_usuario/Registro_de_usuario_screen.dart';
import 'package:widgets_app/Presentation/screens/listadeproductos/lista_de_productos.dart';
// ignore: unused_import


class HomeScreen extends StatefulWidget {
    static const String name = 'home_sreens';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
      //final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:const Text('Inicio',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
      ),
      body: SingleChildScrollView(
        child: _HomeView(),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 246, 255),
    );
  }
}

class Fondo extends StatelessWidget {
  const Fondo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 223, 246, 255)
        ),
      ),
    );
  }
}

class _Sesion extends StatelessWidget {
  const _Sesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController usuario = TextEditingController();
    TextEditingController clave = TextEditingController();
    final formkey = GlobalKey<FormState>();
    final firebase = FirebaseFirestore.instance;
    
    bool usuarioIncorrecto = false;
    bool usuarioIncorrectoSalir = false;      
    validarlogin() async {
      showDialog(
        context: context,
        builder: (context){
          return const Center(child: CircularProgressIndicator(),);
        }
      );
      try{
        CollectionReference ref = firebase.collection('Usuarios');
        QuerySnapshot usuarios = await ref.get();
        if(usuarios.docs.isNotEmpty){
          for(var documento in usuarios.docs){
            if(documento.get('Nombre de usuario') == usuario.text.trim() && documento.get('Clave') == clave.text.trim()){
              usuarioIncorrectoSalir = true;
              var documentoID = documento.id;
              Navigator.push(context,MaterialPageRoute(builder: (context)=> ListaDeProductos(imagenUsuario: documento.get("Imagen"),nombreUsuarioAvatar: documento.get('Nombre'),correoUsuarioAvatar: documento.get('Correo electronico'), documentoID: documentoID,)));
            }
            else{
              usuarioIncorrecto = true;
            }
          }
        }
        
      }catch(e){

      }

      try{
        CollectionReference  ref = firebase.collection('Logistica');
        QuerySnapshot logistica = await ref.get();

        if(logistica.docs.isNotEmpty){
          for(var documento in logistica.docs){
            if(documento.get('Nombre de usuario')==usuario.text.trim() && documento.get('Clave')==clave.text.trim()){
              usuarioIncorrectoSalir = true;
              
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Logistica()));
            }
            else{
              usuarioIncorrecto = true;
            }
          }
        }

      }catch(e){

      }

      if(usuarioIncorrecto == true && usuarioIncorrectoSalir == false){
        
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Datos incorrectos"),
              backgroundColor: const Color.fromARGB(255, 223, 243, 255),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                  child: const Text('Aceptar',style: TextStyle(color: Colors.white),)
                )
              ],
            );
          }
        );
      }
    }


    return Center(
      child: Form(
        key: formkey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max ,
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
                
              const SizedBox(height: 50,),
              Container(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255,2,118,193),
                ),
                child: const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 80, vertical: 50),
                  child: Text('Inicio de sesión', textScaleFactor: 1.5, style:TextStyle(color: Colors.white),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SizedBox(
                    width: 300,
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
                      controller: usuario,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Usuario',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SizedBox(
                    width: 300,
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
                      controller: clave,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration:const  InputDecoration(
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Contraseña',
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
                
              
              const SizedBox(height:20),
              ElevatedButton(
                onPressed: () async{
                  if(formkey.currentState!.validate()){
                    await validarlogin();  
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255,2,118,193)) ,
                child:  const Text('Siguiente',style: TextStyle(color: Colors.white),),
                
                ),
                TextButton(
                  
                  onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> const RegistroUsuario()));
                  },
                  child: const Text('Crear un Nuevo usuario',style: TextStyle(color: Colors.blue),)
                  ),
                // IconButton(
                //   onPressed: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const Logistica()));
                //   },
                //   icon: Icon(Icons.arrow_right)
                // )
            ],    
            
              ),
          
        ),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return _CunstomListTile();
    // return ListView.builder(
    //   itemCount: appMenuItem.length,
    //   itemBuilder: (context, index) {
    //     final menuItem = appMenuItem[index];

    //     return _CunstomListTile(menuItem: menuItem);

    //   },
    // );
  }
}

class _CunstomListTile extends StatelessWidget {
  const _CunstomListTile({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context).colorScheme;
    return   Stack(
        children: [
          const Center(
            child: Fondo(),
          ),
           const Center(
            child: _Sesion(),
          ),
        ],
      );

    // return ListTile(

    //   leading: Icon(menuItem.icon, color: colors.primary),
    //   trailing: Icon(Icons.arrow_forward_ios_rounded,color: colors.primary),
    //   title: Text(menuItem.title),
    //   subtitle: Text(menuItem.subTitle),
    //   onTap: () {
    //     // Navigator.of(context).push(
    //     //   MaterialPageRoute(
    //     //     builder: (context)=>const ButtonsSreen())
    //     // );
    //     //Navigator.pushNamed(context,menuItem.link);
    //     //context.pushNamed(CardsSreen.name);
    //     context.push(menuItem.link);
    //   },
    // );
  }
}
