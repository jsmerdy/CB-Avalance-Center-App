import 'dart:async';
import 'package:cbac_app/src/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'navigation_controls.dart';

class ZoneInfo {
  String link;
  ZoneInfo({required this.link});
}

class NorthWestZone extends StatefulWidget {
  const NorthWestZone({Key? key}) : super(key: key);

  @override
  _NorthWestZoneState createState() => _NorthWestZoneState();
}

class _NorthWestZoneState extends State<NorthWestZone> {
  final zoneInfo = ZoneInfo(link: 'https://cbavalanchecenter.org/forecasts/#/northwest-mountains');
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('North West Zone'),
        actions: [
          NavigationControls(controller: controller)
        ],
      ),
      body: WebViewStack(controller: controller, url: 'https://cbavalanchecenter.org/forecasts/#/northwest-mountains'),
    );
  }
}

class SouthEastZone extends StatefulWidget {
  const SouthEastZone({Key? key}) : super(key: key);

  @override
  _SouthEastZone createState() => _SouthEastZone();
}

class _SouthEastZone extends State<SouthEastZone> {
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('South East Zone'),
        backgroundColor: Colors.black,
        actions: [
          NavigationControls(controller: controller)
        ],
      ),
      body: WebViewStack(controller: controller, url: 'https://cbavalanchecenter.org/forecasts/#/southeast-mountains'),
    );
  }
}