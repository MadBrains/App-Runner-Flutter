import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_runner.dart' show InitializeFunctions, RunnerBuilder;

/// {@template AppBuilder}
/// TODO
/// {@endtemplate}
class AppBuilder<T extends Object> extends StatefulWidget {
  /// {@macro AppBuilder}
  const AppBuilder({
    required this.builder,
    this.child,
    this.preInitialize,
    Key? key,
  }) : super(key: key);

  /// {@macro RunnerBuilder}
  final RunnerBuilder<T> builder;

  /// A [preInitialize]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null.
  final Widget? child;

  /// {@macro InitializeFunctions}
  final InitializeFunctions<T>? preInitialize;

  @override
  _AppBuilderState<T> createState() => _AppBuilderState<T>();
}

class _AppBuilderState<T extends Object> extends State<AppBuilder<T>> {
  late final FutureOr<T>? preInitialize =
      widget.preInitialize?.call(WidgetsBinding.instance!);

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
}
