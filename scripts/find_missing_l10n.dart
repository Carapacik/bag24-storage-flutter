// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  final directory = Directory('lib');

  if (!directory.existsSync()) {
    print('Папка lib не найдена');
    return;
  }

  await for (final FileSystemEntity entity in directory.list(recursive: true)) {
    final String path = entity.path.replaceAll(r'\', '/'); // Универсальный путь для Windows и Unix

    if (entity is File &&
        path.endsWith('.dart') &&
        !path.endsWith('freezed.dart') &&
        !path.endsWith('bloc.dart') &&
        !path.endsWith('event.dart') &&
        !path.endsWith('repository.dart') &&
        !path.endsWith('datasource.dart') &&
        !path.endsWith('dependencies_container.dart') &&
        !path.endsWith('composition_root.dart') &&
        !path.startsWith('lib/src/core/') &&
        !path.startsWith('lib/src/feature/develop_settings/') &&
        !path.startsWith('lib/src/feature/initialization/') &&
        !path.startsWith('lib/src/feature/settings/data/') &&
        !path.startsWith('lib/src/feature/shared_widgets/animation/') &&
        !path.startsWith('lib/src/feature/shared_widgets/button/') &&
        // Временно не провяряем для нового сервиса
        !path.startsWith('lib/src/feature/home/widget/select_send_service_screen.dart') &&
        !path.startsWith('lib/src/feature/passport/widget/passport_data_screen.dart') &&
        !path.startsWith('lib/src/feature/profile/model/passport_data.dart')) {
      final List<String> lines = await entity.readAsLines();

      for (var i = 0; i < lines.length; i++) {
        final String line = lines[i].trim();

        // Пропускаем строки с импортами и part
        if (line.startsWith('import') ||
            line.startsWith('export') ||
            line.startsWith('part') ||
            line.contains('RegExp') ||
            line.contains('toString()') ||
            line.contains('http')) {
          continue;
        }

        // Ищем строки в одинарных кавычках
        final Iterable<RegExpMatch> matches = RegExp("'([^']+)'(?!.*:)").allMatches(line);

        for (final match in matches) {
          final String? foundString = match.group(0);

          if (foundString != null) {
            if (foundString.startsWith("'http") ||
                foundString.startsWith("': ") ||
                foundString.startsWith("' :") ||
                foundString.startsWith(r"'$") ||
                foundString.startsWith(r"' $")) {
              continue;
            }
            print('Файл: $path, Строка ${i + 1}: $foundString');
          }
        }
      }
    }
  }
}
