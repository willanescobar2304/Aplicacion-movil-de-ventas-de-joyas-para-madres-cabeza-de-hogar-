import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_app/Presentation/screens/edicion_de_usuario/actualizar_datos_usuario.dart';

class CambioDeClave extends StatefulWidget {
  final String idDocumentoUsuario;
  const CambioDeClave({super.key, required this.idDocumentoUsuario});

  @override
  State<CambioDeClave> createState() => _CambioDeClaveState();
}
  
class _CambioDeClaveState extends State<CambioDeClave> {
TextEditingController clave = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambio de contraseña',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 2, 118, 193),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Padding(
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
                      controller: clave,
                      keyboardType: TextInputType.name,
                      decoration:const  InputDecoration(
                        labelText: 'Clave',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Clave',
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
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async{
                    if(formkey.currentState!.validate()){
                      await cambioClave(widget.idDocumentoUsuario, clave.text, context).then((value){
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: const Text('La clave fue modificada'),
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
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 118, 193)),
                  child: const Text('Cambiar clave',style: TextStyle(color: Colors.white),)
                )
              ],
            )
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 190, 237, 255),
    );
  }
}