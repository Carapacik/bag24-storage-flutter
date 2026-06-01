import 'package:rest_client/state/dto/app_state_dto.dart';

class const AppState._({
  required final String name,
  required final String latestVersion,
  required final String latestSupportedVersion,
  required final bool technicalWorks,
}) {
  factory decodeDao(AppStateDto dao) => AppState._(
    name: dao.name,
    latestVersion: dao.lastVersion,
    latestSupportedVersion: dao.lastSupportedVersion,
    technicalWorks: dao.technicalWorks,
  );
}
