import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'file_controls.dart';

class NorthWestOfflinePage extends StatefulWidget {
  const NorthWestOfflinePage({Key? key}) : super(key: key);

  @override
  State<NorthWestOfflinePage> createState() => _NorthWestOfflinePageState();
}

class _NorthWestOfflinePageState extends State<NorthWestOfflinePage> {
  late WebViewController controller;

  void loadLocalHtml() async {
    var html = await FileHelper.readContent('northWest');
    controller.loadFile(await FileHelper.getPath("northWest"));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text("North West Offline Page", style: TextStyle(color: Colors.black)),
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