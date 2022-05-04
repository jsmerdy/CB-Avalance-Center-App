import 'dart:async';
import 'dart:io';

import 'package:cbac_app/src/download_zones.dart';
import 'package:cbac_app/src/zone_pages.dart';
import 'package:flutter/material.dart';
import 'package:cbac_app/src/user_page.dart';
import 'package:cbac_app/src/observation_page.dart';
import 'package:cbac_app/src/offline_page.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'src/file_functions.dart';

bool timerRunning = false;

Timer scheduleTimeout([int seconds = 60]) =>
    Timer.periodic(Duration(seconds: seconds), handleTimeout);

Future<void> handleTimeout(Timer t) async {  // callback function
  if (timerRunning) {
    return;
  }
  timerRunning = true;
  try {
    stdout.writeln("handleTimeout");
    var ff = FileFunctions();
    final zipFile = await ff.formEntriesZip;

    if (!zipFile.existsSync()) {
      return;
    }

    final Attachment attachment = FileAttachment(zipFile);
    final List<Attachment> attachments = List<Attachment>.empty(growable: true);
    attachments.add(attachment);
    String username = 'info@upallnitesoftware.com';
    String password = 'Iu123121';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'CbacObservation')
      ..recipients.add('reconzz0263@gmail.com')
      ..subject = 'Test Observation Page Submission :: 😀 :: ${DateTime.now()}'
      ..text = 'See attached'
      ..attachments = attachments;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      zipFile.delete();
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  finally{
    timerRunning = false;
  }
}

void main() {
  scheduleTimeout(5); // 5 seconds.
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
        '/offlinePage': (context) => const OfflinePage(),
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
    image: AssetImage("images/cb background.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset("images/cbacSimpleLogo.png", fit: BoxFit.contain, height: 32),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(icon: Image.asset("images/northWestIcon.webp"), onPressed: () {
                  Navigator.pushNamed(context, '/northWestZone');
                },),
                IconButton(icon: Image.asset("images/southEastIcon.webp"), onPressed: () {
                  Navigator.pushNamed(context, '/southEastZone');
                }),
                IconButton(icon: Image.asset("images/binocularsIcon.jpeg"), onPressed: () {
                  Navigator.pushNamed(context, '/observationPage');
                }),
                IconButton(icon: const Icon(Icons.person), onPressed: () {
                  Navigator.pushNamed(context, '/userPage');
                }),
              ],
            ),
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
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/testPage');
                  },
                  child: const Text('Download Offline Pages'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/offlinePage');
                  },
                  child: const Text('View Offline Page'),
                ),
              ),
            ],
          )
      )
    );
  }
}