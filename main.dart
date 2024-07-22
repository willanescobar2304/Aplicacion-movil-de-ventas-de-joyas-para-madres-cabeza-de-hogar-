import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/config/router/app_router.dart';
// ignore: unused_import

import 'config/theme/add_theme.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selecterColor:0).getTheme(),
    );
  }
}
