import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileFunctions{
  static final FileFunctions _singleton = FileFunctions._internal();

  factory FileFunctions() {
    return _singleton;
  }

  FileFunctions._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> get formEntriesFolder async {
    var path = await _localPath;
    path += '/staging';
    Directory formEntriesFolder = Directory(path);
    if (!formEntriesFolder.existsSync()) {
      formEntriesFolder.createSync();
    }
    return formEntriesFolder.path;
  }

  Future<File> get formEntriesFile async {
    final path = await formEntriesFolder;
    return File('$path/form.csv');
  }

  Future<File> get formEntriesZip async {
    final path = await formEntriesFolder;
    return File('$path/submit.csv');
  }

}