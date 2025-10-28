import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/router/router.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'firebase_options.dart';


void main() async {
  // revisar si flutter inicializó correctamente
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // mantener la posición de la pantalla de forma vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ejecutar service locator
  await setupServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter router = AppRouter().router();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pawcus Focus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
