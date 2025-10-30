import 'package:flutter/widgets.dart';
import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/features/home.dart';
import 'package:pawcus/features/login.dart';
import 'package:pawcus/features/permissions/permissions_screen.dart';
import 'package:pawcus/services/auth_service.dart';


class AppRouter {
  final AuthService authService;

  AppRouter({required this.authService});

  GoRouter router() {
    return GoRouter(
      initialLocation: Routes.home.path,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isAuthenticated = authService.isAuthenticated();
        final isLoginRoute = state.subloc == Routes.login.path;
        if (!isAuthenticated && !isLoginRoute) {
          return Routes.login.path;
        }

        if (isAuthenticated && isLoginRoute) {
          return "${Routes.home.path}?refresh=true";
        }

        return null;
      },
      routes: [
        GoRoute(
          path: Routes.home.path,
          name: Routes.home.name,
          builder: (context, state) {
            final fromLogin = state.queryParams["refresh"] == "true";
            return HomeScreen(key: ValueKey(fromLogin ? DateTime.now() : 'home'));
          },
        ),
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          builder: (context, state) => const LoginScreen(),
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
