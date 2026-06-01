import 'package:bag24/src/feature/system/model/app_state.dart';
import 'package:rest_client/state/state_client.dart';

abstract interface class IAppStateRepository() {
  Future<List<AppState>> get state;

  void setUpdateAvailable();

  bool get isUpdateAvailable;
}

class AppStateRepository({required final StateClient _stateClient}) implements IAppStateRepository {
  bool _isUpdateAvailable = false;

  @override
  Future<List<AppState>> get state async =>
      await _stateClient.getState().then((dao) => dao.result.states.map(AppState.decodeDao).toList());

  @override
  void setUpdateAvailable() => _isUpdateAvailable = true;

  @override
  bool get isUpdateAvailable => _isUpdateAvailable;
}
