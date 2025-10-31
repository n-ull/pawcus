import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/features/home.dart';
import 'package:pawcus/features/login.dart';
import 'package:pawcus/features/permissions/permissions_screen.dart';


class AppRouter {
  GoRouter router() {
    return GoRouter(
      initialLocation: Routes.home.path,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home.path,
          name: Routes.home.name,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: Routes.permissions.path,
          name: Routes.permissions.name,
          builder: (context, state) {
            return const PermissionsScreen();
          },
        ),
      ],
    );
  }
}
