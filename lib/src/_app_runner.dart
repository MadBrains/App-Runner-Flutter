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
      ..scheduleAttachRootWidget(_App(
        widgetConfig: config.widgetConfig,
        preInitialize:
            config.widgetConfig.preInitializeFunctions?.call(binding),
      ))
      ..scheduleForcedFrame();
  }
}

class _App extends StatelessWidget {
  const _App({
    Key? key,
    required this.widgetConfig,
    required this.preInitialize,
  }) : super(key: key);

  final WidgetConfiguration widgetConfig;
  final FutureOr<InitializeResult>? preInitialize;

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

        final FutureOr<InitializeResult>? preInitialize = this.preInitialize;
        final Widget? child = widgetConfig.child;
        if (preInitialize == null && child != null) {
          return child;
        }

        final RunnerBuilder? builder = widgetConfig.builder;
        if (builder != null) {
          if (preInitialize is! Future<InitializeResult>) {
            return builder(
              context,
              AsyncSnapshot<InitializeResult>.withData(
                ConnectionState.done,
                preInitialize as InitializeResult,
              ),
              child,
            );
          }

          return FutureBuilder<InitializeResult>(
            future: preInitialize,
            builder: (BuildContext context,
                AsyncSnapshot<InitializeResult> snapshot) {
              if (snapshot.hasError) {
                final Object? error = snapshot.error;
                final StackTrace stackTrace =
                    snapshot.stackTrace ?? StackTrace.current;
                if (error != null) {
                  Zone.current.handleUncaughtError(error, stackTrace);
                }
              }
              return builder(context, snapshot, child);
            },
          );
        }

        throw Exception(); // TODO
      },
    );
  }
}
