import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cbac_app/src/file_controls.dart';

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
    print(body);
    await FileHelper.writeContent('southEast', body);
    await FileHelper.readContent('southEast');
  } else {
    throw Exception('failed to load');
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                getNorthWest();
              },
              child: const Text("download northwest zone"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                getSouthEast();
              },
              child: const Text("download southeast zone"),
            ),
          ),
        ]
      ),
    );
  }
}