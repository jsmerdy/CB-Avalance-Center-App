import 'package:cbac_app/src/download_zones.dart';
import 'package:cbac_app/src/northwest_offline.dart';
import 'package:cbac_app/src/southeast_offline.dart';
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
        '/testPage': (context) => const TestPage(),
        '/northWestOfflinePage': (context) => const NorthWestOfflinePage(),
        '/southEastOfflinePage': (context) => const SouthEastOfflinePage(),
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
                image: AssetImage("images/cb background.jpg"),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset("images/cbacSimpleLogo.png",
                fit: BoxFit.contain, height: 32),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset("images/northWestIcon.webp"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/northWestZone');
                  },
                ),
                IconButton(
                    icon: Image.asset("images/southEastIcon.webp"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/southEastZone');
                    }),
                IconButton(
                    icon: Image.asset("images/binocularsIcon.jpeg"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/observationPage');
                    }),
                IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.pushNamed(context, '/userPage');
                    }),
              ],
            ),
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/northWestZone');
                    },
                    child: const Text('North West Zone'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/southEastZone');
                    },
                    child: const Text('South East Zone'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/observationPage');
                    },
                    child: const Text('Observation Page'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/userPage');
                    },
                    child: const Text('User Page'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/testPage');
                    },
                    child: const Text('Download Offline Pages'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/northWestOfflinePage');
                    },
                    child: const Text('View North West Offline Page'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/southEastOfflinePage');
                    },
                    child: const Text('View South East Offline Page'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
