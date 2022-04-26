import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  static Future<File> get _northWestLocalFile async {
    final path = await _localPath;
    return File('$path/northWest.html');
  }

  static Future<File> get _southEastLocalFile async {
    final path = await _localPath;
    return File('$path/southEast.html');
  }

  static Future<String> getPath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    if(filename == 'northWest') {
      return "${directory.path}/northWest.html";
    }
    else if(filename == 'southEast') {
      return "${directory.path}/southEast.html";
    }
    else {
      return "DNE";
    }
  }

  static Future writeContent(String filename, String htmlBody) async {
    if(filename == 'northWest') {
      final file = await _northWestLocalFile;
      file.writeAsString(htmlBody);
    }
    else if(filename == 'southEast') {
      final file = await _southEastLocalFile;
      file.writeAsString(htmlBody);
    }
  }

  static Future<String> readContent(String filename) async {
    if(filename == 'northWest') {
      try {
        final file = await _northWestLocalFile;
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        return 'Error!';
      }
    }
    else if(filename == 'southEast') {
      try {
        final file = await _southEastLocalFile;
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        return 'Error!';
      }
    }
    else {
      return "Something went wrong...";
    }
  }
}