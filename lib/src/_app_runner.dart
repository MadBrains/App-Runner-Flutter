part of 'app_runner.dart';

mixin _AppRunner on WidgetsBinding {
  static void run(RunnerConfiguration config) {
    runZonedGuarded<void>(
      () async {
        final WidgetsBinding binding =
            config.widgetConfig.initializeBinding?.call() ??
                WidgetsFlutterBinding.ensureInitialized();

        _attachSplash(config.widgetConfig.splash, binding);

        await _preInitializeFunctions(config.preInitializeFunctions, binding);

        _attachApp(_App(widgetConfig: config.widgetConfig), binding);
      },
      config.zoneConfig.onZoneError,
      zoneValues: config.zoneConfig.zoneValues,
      zoneSpecification: config.zoneConfig.zoneSpecification,
    );
  }

  static void _attachSplash(Widget? splash, WidgetsBinding binding) {
    if (splash != null) {
      binding
        ..scheduleAttachRootWidget(splash)
        ..scheduleWarmUpFrame();
    }
  }

  static Future<void> _preInitializeFunctions(
      InitializeFunctions? preInitialize, WidgetsBinding binding) async {
    if (preInitialize != null) {
      await preInitialize(binding);
    }
  }

  static void _attachApp(Widget app, WidgetsBinding binding) {
    binding
      ..scheduleAttachRootWidget(app)
      ..scheduleForcedFrame();
  }
}

class _App extends StatelessWidget {
  const _App({Key? key, required this.widgetConfig}) : super(key: key);

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
        return widgetConfig.app;
      },
    );
  }
}
