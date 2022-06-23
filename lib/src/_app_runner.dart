part of 'app_runner.dart';

mixin _AppRunner on WidgetsBinding {
  static void run(RunnerConfiguration config) {
    if (config is _RunnerConfigurationGuarded) {
      runZonedGuarded<void>(
        () => _attach(config),
        config.zoneConfig.onZoneError,
        zoneValues: config.zoneConfig.zoneValues,
        zoneSpecification: config.zoneConfig.zoneSpecification,
      );
    } else {
      _attach(config);
    }
  }

  static void _attach(RunnerConfiguration config) {
    final WidgetsBinding binding =
        config.widgetConfig.initializeBinding?.call() ??
            WidgetsFlutterBinding.ensureInitialized();

    binding
      ..scheduleAttachRootWidget(
        _App(
          widgetConfig: config.widgetConfig,
        ),
      )
      ..scheduleForcedFrame();
  }
}

class _App extends StatelessWidget {
  const _App({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  final WidgetConfiguration widgetConfig;

  @override
  Widget build(BuildContext context) {
    return ReloadableWidget(
      builder: (BuildContext context) {
        FlutterError.onError = widgetConfig.onFlutterError;
        ErrorWidget.builder =
            (FlutterErrorDetails errorDetails) => ErrorHandlerWidget(
                  errorDetails: errorDetails,
                  releaseErrorBuilder: widgetConfig.releaseErrorBuilder,
                  errorBuilder: widgetConfig.errorBuilder,
                );

        return widgetConfig.child;
      },
    );
  }
}
