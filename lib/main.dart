import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:rollbar_flutter_aio/rollbar.dart' as rollbar;

import 'package:pawcus/core/logger.dart';
import 'package:pawcus/core/router/router.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // revisar si flutter inicializó correctamente
  WidgetsFlutterBinding.ensureInitialized();

  await setupLogging();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // mantener la posición de la pantalla de forma vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ejecutar service locator
  await setupServiceLocator();

  // TODO: Make this configurable through the env
  final useRollbar = false;

  final app = MyApp();

  if (useRollbar) {
    runWithRollbar(app);
  } else {
    runApp(app);
  }
}


Future<void> runWithRollbar(MyApp app) async {
  // TODO: Make this configurable through the env
  const config = rollbar.Config(
    accessToken: 'ACCESS_TOKEN',
    environment: 'ENVIRONMENT',
    codeVersion: 'CODE_VERSION',
    handleUncaughtErrors: true,
    includePlatformLogs: true,
  );

  await rollbar.RollbarFlutter.run(config, () => runApp(app));
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
      scaffoldMessengerKey: GlobalKey(debugLabel: "scaffoldMessenger"),
    );
  }
}
