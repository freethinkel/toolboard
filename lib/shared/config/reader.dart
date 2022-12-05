import 'dart:io';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class ConfigReader {
  final _locations = [
    join(Platform.environment['HOME']!, '.toolboard.yml'),
    join(Platform.environment['HOME']!, '.config', 'toolboard', 'config.yml')
  ];

  Future<Map?> readConfig() async {
    final file = (await Future.wait(_locations.map((path) async {
      if (await File(path).exists()) {
        return File(path);
      }
      return null;
    })))
        .firstWhere((file) => file != null);

    if (file == null) {
      return null;
    }

    final fileData = await file.readAsString();
    return loadYaml(fileData);
  }
}
