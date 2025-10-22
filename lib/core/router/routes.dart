class Routes {
  static const home = _Route('/', 'Home');
  static const login = _Route('/login', 'Login');
}

class _Route {
  final String path;
  final String name;

  const _Route(this.path, this.name);
}