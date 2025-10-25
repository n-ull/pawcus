import 'package:hive/hive.dart';

class FakeBox extends Box {
  FakeBox(Map map);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
