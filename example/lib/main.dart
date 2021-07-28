import 'dart:developer' as dev;

import 'package:app_runner/app_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
class CustomWidgetsFlutterBinding extends WidgetsFlutterBinding {
  ///
  static WidgetsBinding? ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      CustomWidgetsFlutterBinding();
    }
    return WidgetsBinding.instance;
  }
}

void main() {
  appRunner(
    RunnerConfiguration(
      widgetConfig: WidgetConfiguration(
        app: MyApp(),
        splash: const Splash(),
        onFlutterError: (FlutterErrorDetails errorDetails) {
          dev.log(errorDetails.toString(),
              name: 'onFlutterError', stackTrace: errorDetails.stack);
        },
        initializeBinding: () => CustomWidgetsFlutterBinding(),
      ),
      zoneConfig: ZoneConfiguration(
        onZoneError: (Object error, StackTrace stackTrace) {
          dev.log(error.toString(),
              name: 'onZoneError', stackTrace: stackTrace);
        },
      ),
      preInitializeFunctions: (WidgetsBinding binding) async {
        await Future<void>.delayed(const Duration(milliseconds: 2000));
      },
    ),
  );
}

///
class Splash extends StatelessWidget {
  ///
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Loading'),
        ),
      ),
    );
  }
}

///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

///
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  ///
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _push() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MyPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(hashCode.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _push,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}

///
class MyPage extends StatelessWidget {
  ///
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(hashCode.toString()),
            TextButton(
              onPressed: () {
                context.reloadWidget();
              },
              child: const Text('Reload Widget'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ExceptionPage(),
                  ),
                );
              },
              child: const Text('Go to ExceptionPage'),
            ),
            TextButton(
              onPressed: () {
                Future<void>.error(Exception('Zone Exception'));
                throw Exception('Widget Exception');
              },
              child: const Text('Throw Exception'),
            ),
          ],
        ),
      ),
    );
  }
}

///
class ExceptionPage extends StatelessWidget {
  ///
  const ExceptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw Exception('test');
  }
}
