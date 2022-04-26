import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'file_controls.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({Key? key}) : super(key: key);

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  late WebViewController controller;

  void loadLocalHtml() async {
    controller.loadFile(await FileHelper.getPath("southEast"));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Offline Page"),
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