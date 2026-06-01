import 'dart:convert';
import 'dart:io';

import 'package:file/src/interface/file_system_entity.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

void main() {
  final String root = Directory.current.path;
  final String rootPosix = root.replaceAll(r'\', '/');

  final Set<String> stringKeys = getStringKeys(rootPosix);
  final List<String> dartFiles = getDartFiles(rootPosix);

  final Set<String> unusedStringKeys = findUnusedStringKeys(stringKeys, dartFiles);

  for (final stringKey in unusedStringKeys) {
    // ignore: avoid_print
    print(stringKey);
  }
}

Set<String> getStringKeys(String path) {
  final arbFilesGlob = Glob('$path/**.arb');

  final arbFiles = <String>[];
  for (final FileSystemEntity entity in arbFilesGlob.listSync(followLinks: false)) {
    arbFiles.add(entity.path);
  }

  final stringKeys = <String>{};
  for (final file in arbFiles) {
    final String content = File(file).readAsStringSync();
    final map = jsonDecode(content) as Map<String, dynamic>;
    for (final MapEntry<String, dynamic> entry in map.entries) {
      if (!entry.key.startsWith('@')) {
        stringKeys.add(entry.key);
      }
    }
  }

  return stringKeys;
}

List<String> getDartFiles(String path) {
  final dartFilesGlob = Glob('$path/**.dart');
  final dartFilesExcludeGlob = Glob('$path/lib/src/core/constant/localization/generated/**.dart');

  final dartFilesExclude = <String>[];
  for (final FileSystemEntity entity in dartFilesExcludeGlob.listSync(followLinks: false)) {
    dartFilesExclude.add(entity.path);
  }

  final dartFiles = <String>[];
  for (final FileSystemEntity entity in dartFilesGlob.listSync(followLinks: false)) {
    if (!dartFilesExclude.contains(entity.path)) {
      dartFiles.add(entity.path);
    }
  }

  return dartFiles;
}

Set<String> findUnusedStringKeys(Set<String> stringKeys, List<String> files) {
  final Set<String> unusedStringKeys = stringKeys.toSet();

  for (final file in files) {
    final String content = File(file).readAsStringSync();
    for (final stringKey in stringKeys) {
      if (content.contains(stringKey)) {
        unusedStringKeys.remove(stringKey);
      }
    }
  }

  return unusedStringKeys;
}
