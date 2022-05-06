import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'file_controls.dart';

class SouthEastOfflinePage extends StatefulWidget {
  const SouthEastOfflinePage({Key? key}) : super(key: key);

  @override
  State<SouthEastOfflinePage> createState() => _SouthEastOfflinePageState();
}

class _SouthEastOfflinePageState extends State<SouthEastOfflinePage> {
  late WebViewController controller;

  void loadLocalHtml() async {
    var html = await FileHelper.readContent('southEast');
    controller.loadFile(await FileHelper.getPath("southEast"));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text("South East Offline Page", style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
    ),
    body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: '',
        onWebViewCreated: (controller) {
          loadLocalHtml();
          this.controller = controller;
        }
    ),
  );
}