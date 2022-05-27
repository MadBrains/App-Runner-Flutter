// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer' as dev;

import 'package:app_runner/app_runner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void log(
  Object? message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  dev.log(
    message?.toString() ?? '',
    time: time,
    sequenceNumber: sequenceNumber,
    level: level,
    name: name,
    zone: zone,
    error: error,
    stackTrace: stackTrace,
  );
}

class CustomWidgetsFlutterBinding extends WidgetsFlutterBinding {
  // @override
  // ViewConfiguration createViewConfiguration() {
  //   const double ratio = 4.0;
  //   return ViewConfiguration(
  //     size: window.physicalSize / ratio,
  //     devicePixelRatio: ratio,
  //   );
  // }
}

void main() {
  final WidgetConfiguration widgetConfiguration = WidgetConfiguration(
    child: AppBuilder<String>(
      preInitialize: (WidgetsBinding binding) async {
        log('binding type: ${binding.runtimeType}');
        await Future<void>.delayed(const Duration(milliseconds: 2000));
        // throw Exception('test preInitializeFunctions');
        return 'Mad Brains';
      },
      builder: (
        BuildContext context,
        AsyncSnapshot<String?> snapshot,
        Widget? child,
      ) {
        late final Widget _child;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            _child = const Splash();
            continue display;
          case ConnectionState.done:
            final String? data = snapshot.data;
            log(data);
            _child = const MyApp();
            continue display;
          display:
          default:
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _child,
            );
        }
      },
    ),
    onFlutterError: (FlutterErrorDetails errorDetails) {
      log(
        errorDetails.toStringShort(),
        name: 'onFlutterError',
        stackTrace: errorDetails.stack,
        error: errorDetails.exception,
      );
    },
    initializeBinding: () => CustomWidgetsFlutterBinding(),
  );

  final ZoneConfiguration zoneConfiguration = ZoneConfiguration(
    onZoneError: (Object error, StackTrace stackTrace) {
      log(
        error.runtimeType.toString(),
        name: 'onZoneError',
        stackTrace: stackTrace,
        error: error,
      );
    },
  );

  appRunner(
    kIsWeb
        ? RunnerConfiguration(widgetConfig: widgetConfiguration)
        : RunnerConfiguration.guarded(
            widgetConfig: widgetConfiguration,
            zoneConfig: zoneConfiguration,
          ),
  );
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading'),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp();

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

class MyPage extends StatelessWidget {
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

class ExceptionPage extends StatelessWidget {
  const ExceptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw Exception('test');
  }
}
