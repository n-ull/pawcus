class Routes {
static const home = _Route('/', 'Home');
static const permissions = _Route('/permissions', 'Permissions');
}

class _Route {
  final String path;
  final String name;

  const _Route(this.path, this.name);
}