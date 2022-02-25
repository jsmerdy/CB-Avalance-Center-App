import 'dart:async';
import 'package:cbac_app/src/navigation_controls.dart';
import 'package:cbac_app/src/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/northWestZone': (context) => const NorthWestZone(),
        '/southEastZone': (context) => const SouthEastZone(),
        '/observationPage': (context) => const ObservationPage(),
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                // Within the `FirstScreen` widget
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/northWestZone');
                },
                child: const Text('North West Zone'),
              ),
            ),
            Center(
              child: ElevatedButton(
                // Within the `FirstScreen` widget
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/southEastZone');
                },
                child: const Text('South East Zone'),
              ),
            ),
            Center(
              child: ElevatedButton(
                // Within the `FirstScreen` widget
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/observationPage');
                },
                child: const Text('Observation Page'),
              ),
            ),
          ],
        )
    );
  }
}

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
        title: const Text('North West Zone'),
        actions: [
          NavigationControls(controller: controller)
        ],
      ),
      body: WebViewStack(controller: controller),
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
        actions: [
          NavigationControls(controller: controller)
        ],
      ),
      body: WebViewStack(controller: controller),
    );
  }
}

class ObservationPage extends StatelessWidget {
  const ObservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Observation Page"),
      ),
    );
  }
}