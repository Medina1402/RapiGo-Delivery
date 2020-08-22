import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManagerService {
  /*
   *
   */
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  /*
   *
   */
  Future<File> getFile(String filename) async {
    final String _path = await _localPath;
    final String _completePath = _path.toString() + "/" + filename;
    return File(_completePath);
  }

  /*
   *
   */
  Future<String> readFile(String filename) async {
    try {
      final File _file = await getFile(filename);
      final String _content = await _file.readAsString();
      return _content;
    } catch (e) {
      return null;
    }
  }

  /*
   *
   */
  Future<File> writeFile(String filename, String content) async {
    final File _file = await getFile(filename);
    return _file.writeAsString(content);
  }

  /*
   *
   */
  Future<void> removeFile(String filename) async {
    final File _file = await getFile(filename);
    await _file.delete();
  }
}