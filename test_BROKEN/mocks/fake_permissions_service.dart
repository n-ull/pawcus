import 'package:pawcus/core/services/permissions_service.dart';

class FakePermissionsService extends PermissionsService {
  final bool _hasAccess;

  FakePermissionsService(this._hasAccess);

  @override
  Future<bool> hasUsageAccess() async => _hasAccess;

  @override
  Future<bool> hasOverlayPermission() async => _hasAccess;
}
