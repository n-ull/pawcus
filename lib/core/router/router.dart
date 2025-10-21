import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/router/routes.dart';

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
            return const Placeholder(color: Colors.red,);
          },
        ),
      ],
    );
  }
}
