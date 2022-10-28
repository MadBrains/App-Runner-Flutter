// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer' as dev;

import 'package:app_runner/app_runner.dart';
import 'package:example/app.dart';
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
        ? RunnerConfiguration(
            widgetConfig: widgetConfiguration,
            onPlatformError: (Object exception, StackTrace stackTrace) {
              log(
                exception.runtimeType.toString(),
                name: 'onPlatformError',
                stackTrace: stackTrace,
                error: exception,
              );

              return false;
            },
          )
        : RunnerConfiguration.guarded(
            widgetConfig: widgetConfiguration,
            zoneConfig: zoneConfiguration,
          ),
  );
}
