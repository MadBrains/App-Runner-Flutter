import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_runner.dart' show InitializeFunctions, RunnerBuilder;

/// {@template AppBuilder}
/// AppBuilder main widget to use in WidgetConfiguration.
///
/// [builder] -
/// {@macro RunnerBuilder}
///
/// [child] -
/// {@macro AppBuilder.child}
///
/// [preInitialize] -
/// {@macro InitializeFunctions}
///
/// If preInitialize is null or not a Future, then the builder is called with the completed AsyncSnapshot.
/// Otherwise creates a widget that builds itself based on the latest snapshot of interaction with a [Future].
/// {@endtemplate}
class AppBuilder<T extends Object?> extends StatefulWidget {
  /// {@macro AppBuilder}
  const AppBuilder({
    required this.builder,
    this.child,
    this.preInitialize,
    Key? key,
  }) : super(key: key);

  /// {@macro RunnerBuilder}
  final RunnerBuilder<T> builder;

  /// {@template AppBuilder.child}
  /// A [preInitialize]-independent widget which is passed back to the [builder].
  /// This argument is optional and can be null.
  /// {@endtemplate}
  final Widget? child;

  /// {@macro InitializeFunctions}
  final InitializeFunctions<T>? preInitialize;

  @override
  _AppBuilderState<T> createState() => _AppBuilderState<T>();
}

class _AppBuilderState<T extends Object?> extends State<AppBuilder<T>> {
  late final FutureOr<T>? preInitialize = widget.preInitialize?.call(WidgetsBinding.instance);

  @override
  Widget build(BuildContext context) {
    final RunnerBuilder<T> builder = widget.builder;
    late final Widget? child = widget.child;
    final FutureOr<T>? preInitialize = this.preInitialize;

    if (preInitialize == null) {
      return builder(
        context,
        AsyncSnapshot<T?>.withData(
          ConnectionState.done,
          null,
        ),
        child,
      );
    }

    if (preInitialize is! Future<T>) {
      return builder(
        context,
        AsyncSnapshot<T>.withData(
          ConnectionState.done,
          preInitialize,
        ),
        child,
      );
    }

    return FutureBuilder<T>(
      future: preInitialize,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        final Object? error = snapshot.error;
        if (error != null) {
          final StackTrace stackTrace = snapshot.stackTrace ?? StackTrace.current;
          Zone.current.handleUncaughtError(error, stackTrace);
        }

        return builder(context, snapshot, child);
      },
    );
  }
}
