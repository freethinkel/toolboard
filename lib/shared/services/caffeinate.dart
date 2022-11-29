import 'dart:developer';
import 'dart:io';

class Caffeinate {
  static Caffeinate instance = Caffeinate();
  int? _pid;

  bool get enable {
    return _pid != null;
  }

  Future<bool> start() async {
    try {
      final result = await Process.start("caffeinate", ['-di']);
      _pid = result.pid;
      return true;
    } catch (err) {
      log("caffeinate err: $err");
      return false;
    }
  }

  bool stop() {
    if (_pid != null) {
      final result = Process.killPid(_pid!);
      _pid = null;
      return result;
    }

    return false;
  }
}
