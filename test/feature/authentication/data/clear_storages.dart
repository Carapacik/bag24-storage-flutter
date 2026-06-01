import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<ClearStorages>()])
abstract class ClearStorages() {
  Future<void> clearStorages();
}
