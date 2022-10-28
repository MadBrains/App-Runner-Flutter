// ignore_for_file: public_member_api_docs

import 'package:app_runner/app_runner.dart';
import 'package:example/app.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  final WidgetConfiguration widgetConfiguration = WidgetConfiguration(
    child: AppBuilder<void>(
      preInitialize: (WidgetsBinding binding) async {
        // Sentry integration
        await SentryFlutter.init(
          (SentryFlutterOptions options) {
            options
              ..dsn =
                  'https://39d719ac19df4b83904adbf0be3eb945@o224510.ingest.sentry.io/4504060945498112'
              ..tracesSampleRate = 1.0
              ..autoAppStart = false
              ..debug = true;
          },
        );

        return;
      },
      builder: (
        BuildContext context,
        AsyncSnapshot<void> snapshot,
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
            SentryFlutter.setAppStartEnd(DateTime.now());
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
    onFlutterError: (FlutterErrorDetails errorDetails) async {
      await Sentry.captureException(
        errorDetails.exception,
        stackTrace: errorDetails.stack,
      );
    },
  );

  final ZoneConfiguration zoneConfiguration = ZoneConfiguration(
    onZoneError: (Object error, StackTrace stackTrace) async {
      await Sentry.captureException(error, stackTrace: stackTrace);
    },
  );

  appRunner(
    true
        ? RunnerConfiguration(
            widgetConfig: widgetConfiguration,
            onPlatformError: (Object exception, StackTrace stackTrace) {
              Sentry.captureException(exception, stackTrace: stackTrace);

              return false;
            },
          )
        : RunnerConfiguration.guarded(
            widgetConfig: widgetConfiguration,
            zoneConfig: zoneConfiguration,
          ),
  );
}
