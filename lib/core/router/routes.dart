class Routes {
static const home = _Route('/', 'Home');
}

class _Route {
  final String path;
  final String name;

  const _Route(this.path, this.name);
}