part of 'app_runner.dart';

/// {@template InitializeBinding}
/// Callback to use your WidgetsBinding instance
/// {@endtemplate}
typedef InitializeBinding = WidgetsBinding Function();

/// {@template InitializeFunctions}
/// A callback to initialize your code.
/// Responsible for initializing custom methods, such as `Firebase`, `Sentry`, etc.
/// {@endtemplate}
typedef InitializeFunctions<T> = FutureOr<T> Function(WidgetsBinding binding);

/// {@template RunnerBuilder}
/// TODO
/// {@endtemplate}
typedef RunnerBuilder<T> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T?> snapshot,
  Widget? child,
);

/// {@template OnError}
/// The [onError] function is used both to handle asynchronous errors by overriding [ZoneSpecification.handleUncaughtError] in [zoneSpecification], if any, and to handle errors thrown synchronously by the call to [body].
/// {@endtemplate}
typedef OnError = void Function(Object error, StackTrace stackTrace);

/// {@template ErrorWidgetBuilder}
/// Custom Builder for error handling in debug and profile mode
/// {@endtemplate}
typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  FlutterErrorDetails errorDetails,
);

/// {@template RunnerConfiguration}
/// Runner Configuration
/// {@endtemplate}
@immutable
abstract class RunnerConfiguration {
  /// Runner Configuration
  /// - [widgetConfig] is responsible for configuring launched widgets and handling errors in widgets;
  const factory RunnerConfiguration({
    required WidgetConfiguration widgetConfig,
  }) = _RunnerConfiguration;

  /// Runner Configuration Guarded
  /// - [widgetConfig] is responsible for configuring launched widgets and handling errors in widgets;
  /// - [zoneConfig] responsible for the zone configuration in which your application will be launched;
  const factory RunnerConfiguration.guarded({
    required WidgetConfiguration widgetConfig,
    required ZoneConfiguration zoneConfig,
  }) = _RunnerConfigurationGuarded;

  const RunnerConfiguration._(this.widgetConfig);

  /// {@macro WidgetConfiguration}
  final WidgetConfiguration widgetConfig;
}

class _RunnerConfiguration extends RunnerConfiguration {
  /// {@macro RunnerConfiguration}
  const _RunnerConfiguration({
    required WidgetConfiguration widgetConfig,
  }) : super._(widgetConfig);
}

class _RunnerConfigurationGuarded extends RunnerConfiguration {
  /// {@macro RunnerConfiguration}
  const _RunnerConfigurationGuarded({
    required WidgetConfiguration widgetConfig,
    required this.zoneConfig,
  }) : super._(widgetConfig);

  /// {@macro ZoneConfiguration}
  final ZoneConfiguration zoneConfig;
}

/// {@template WidgetConfiguration}
/// Widget configuration, takes in itself:
/// - [child] widget of your application;
/// - [onFlutterError] error handler for flutter widgets;
/// - [errorBuilder] handler for handling error screen in debug and profile mode. Attention! This widget fragile, do not do it loaded his best done through [LeafRenderObjectWidget];
/// - [releaseErrorBuilder] handler for handling error screen in release mode. Attention! This widget fragile, do not do it loaded his best done through [LeafRenderObjectWidget];
/// - [initializeBinding] is responsible for initializing your [WidgetsBinding];
/// {@endtemplate}
@immutable
class WidgetConfiguration {
  /// {@macro WidgetConfiguration}
  const WidgetConfiguration({
    required this.child,
    required this.onFlutterError,
    this.errorBuilder,
    this.releaseErrorBuilder,
    this.initializeBinding,
  });

  /// Your application widget
  final Widget child;

  /// Called whenever the Flutter framework catches an error.
  final void Function(FlutterErrorDetails errorDetails) onFlutterError;

  /// {@macro ErrorWidgetBuilder}
  final ErrorWidgetBuilder? errorBuilder;

  /// Custom Builder for error handling in release mode
  final WidgetBuilder? releaseErrorBuilder;

  /// {@macro InitializeBinding}
  final InitializeBinding? initializeBinding;
}

/// {@template ZoneConfiguration}
/// Zone configuration, takes in itself:
/// - [onZoneError] zone error handler;
/// - [zoneValues] local data for a specific zone;
/// - [zoneSpecification] zone specification;
/// {@endtemplate}
@immutable
class ZoneConfiguration {
  /// {@macro ZoneConfiguration}
  const ZoneConfiguration({
    required this.onZoneError,
    this.zoneValues,
    this.zoneSpecification,
  });

  /// {@macro OnError}
  final OnError onZoneError;

  /// Local zone values
  final Map<Object, Object>? zoneValues;

  /// A parameter object with custom zone function handlers for [Zone.fork].
  final ZoneSpecification? zoneSpecification;
}
