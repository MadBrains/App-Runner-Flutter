part of 'app_runner.dart';

/// {@template InitializeBinding}
/// Callback to use your WidgetsBinding instance
/// {@endtemplate}
typedef InitializeBinding = WidgetsBinding Function();

/// {@template InitializeFunctions}
/// A callback to initialize your code. Called during splash display (if any)
/// {@endtemplate}
typedef InitializeFunctions = FutureOr<void> Function(WidgetsBinding binding);

/// {@template OnError}
/// The [onError] function is used both to handle asynchronous errors by overriding [ZoneSpecification.handleUncaughtError] in [zoneSpecification], if any, and to handle errors thrown synchronously by the call to [body].
/// {@endtemplate}
typedef OnError = void Function(Object error, StackTrace stackTrace);

/// {@template ErrorWidgetBuilder}
/// Custom Builder for error handling in debug and profile mode
/// {@endtemplate}
typedef ErrorWidgetBuilder = Widget Function(
    BuildContext context, FlutterErrorDetails errorDetails);

/// {@template RunnerConfiguration}
/// Runner Configuration, takes in itself:
/// - [widgetConfig] is responsible for configuring launched widgets and handling errors in widgets;
/// - [zoneConfig] responsible for the zone configuration in which your application will be launched;
/// - [initializeBinding] is responsible for initializing your [WidgetsBinding]
/// - [preInitializeFunctions] responsible for initializing custom methods, such as `Firebase` or `Sentry`.
/// {@endtemplate}
@immutable
class RunnerConfiguration {
  /// {@macro RunnerConfiguration}
  const RunnerConfiguration({
    required this.widgetConfig,
    required this.zoneConfig,
    this.preInitializeFunctions,
  });

  /// {@macro WidgetConfiguration}
  final WidgetConfiguration widgetConfig;

  /// {@macro ZoneConfiguration}
  final ZoneConfiguration zoneConfig;

  /// {@macro InitializeFunctions}
  final InitializeFunctions? preInitializeFunctions;
}

/// {@template WidgetConfiguration}
/// Widget configuration, takes in itself:
/// - [app] widget of your application;
/// - [onFlutterError] error handler for flutter widgets;
/// - [splash] loading widget of your application, completely independent of the [app];
/// - [errorBuilder] handler for handling error screen in debug and profile mode. Attention! This widget fragile, do not do it loaded his best done through [LeafRenderObjectWidget];
/// - [releaseErrorBuilder] handler for handling error screen in release mode. Attention! This widget fragile, do not do it loaded his best done through [LeafRenderObjectWidget].
/// {@endtemplate}
@immutable
class WidgetConfiguration {
  /// {@macro WidgetConfiguration}
  const WidgetConfiguration({
    required this.app,
    required this.onFlutterError,
    this.splash,
    this.errorBuilder,
    this.releaseErrorBuilder,
    this.initializeBinding,
  });

  /// Your application widget
  final Widget app;

  /// Called whenever the Flutter framework catches an error.
  final void Function(FlutterErrorDetails errorDetails) onFlutterError;

  /// Your splash widget
  final Widget? splash;

  /// {@macro ErrorWidgetBuilder}
  final ErrorWidgetBuilder? errorBuilder;

  /// Custom Builder for error handling in release mode
  final WidgetBuilder? releaseErrorBuilder;

  /// {@macro InitializeBinding}
  final InitializeBinding? initializeBinding;
}

/// {@template ZoneConfiguration}
/// Zone configuration, takes in itself:
/// - [onZoneError] zone error handler
/// - [zoneValues] local data for a specific zone
/// - [zoneSpecification] zone specification
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
