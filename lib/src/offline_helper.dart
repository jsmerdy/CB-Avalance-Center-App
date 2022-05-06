import 'package:http/http.dart' as http;
import 'package:cbac_app/src/file_controls.dart';

class OfflineHelper {
  Future getNorthWest() async {
    final response = await http
        .get(Uri.parse('http://54.176.36.158/northwest'));

    if (response.statusCode == 200) {
      var body = response.body;
      await FileHelper.writeContent('northWest', body);
      await FileHelper.readContent('northWest');
    } else {
      throw Exception('failed to load');
    }
  }

  Future getSouthEast() async {
    final response = await http
        .get(Uri.parse('http://54.176.36.158/southeast'));

    if (response.statusCode == 200) {
      var body = response.body;
      await FileHelper.writeContent('southEast', body);
      await FileHelper.readContent('southEast');
    } else {
      throw Exception('failed to load');
    }
  }
}