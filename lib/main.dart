import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/models/settings.dart';
import 'package:rollbar_flutter_aio/rollbar.dart' as rollbar;

import 'package:pawcus/core/logger.dart';
import 'package:pawcus/core/router/router.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // revisar si flutter inicializó correctamente
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final configuration = AppConfiguration.fromEnv();

  await setupLogging(configuration);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // mantener la posición de la pantalla de forma vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ejecutar service locator
  await setupServiceLocator();

  final app = MyApp();

  if (configuration.useRollbar) {
    runWithRollbar(configuration, app);
  } else {
    runApp(app);
  }
}


Future<void> runWithRollbar(AppConfiguration configuration, MyApp app) async {
  final config = rollbar.Config(
    accessToken: configuration.rollbarAccessToken,
    environment: configuration.environment.toString(),
    codeVersion:  configuration.rollbarAccessToken,
    handleUncaughtErrors: true,
    includePlatformLogs: true,
    framework: 'flutter',
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
