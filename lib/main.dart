import 'package:cbac_app/src/zone_pages.dart';
import 'package:flutter/material.dart';
import 'package:cbac_app/src/user_page.dart';
import 'package:cbac_app/src/observation_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/northWestZone': (context) => const NorthWestZone(),
        '/southEastZone': (context) => const SouthEastZone(),
        '/observationPage': (context) => const ObservationPage(),
        '/userPage': (context) => const UserPage(),
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("images/TestPic.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Home Screen'),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/northWestZone');
                  },
                  child: const Text('North West Zone'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/southEastZone');
                  },
                  child: const Text('South East Zone'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/observationPage');
                  },
                  child: const Text('Observation Page'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/userPage');
                  },
                  child: const Text('User Page'),
                ),
              )
            ],
          )
      )
    );
  }
}