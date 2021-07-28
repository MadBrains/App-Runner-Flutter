part of 'app_runner.dart';

/// {@template ErrorHandlerWidget}
/// Widget that catches and handles widget errors
/// {@endtemplate}
class ErrorHandlerWidget extends StatelessWidget {
  /// {@macro ErrorHandlerWidget}
  ErrorHandlerWidget({
    required this.errorDetails,
    this.releaseErrorBuilder,
    this.errorBuilder,
  }) : super(key: UniqueKey());

  /// Error information provided to [FlutterExceptionHandler] callbacks.
  final FlutterErrorDetails errorDetails;

  /// Widget for error handling in debug and profile mode
  final ErrorWidgetBuilder? errorBuilder;

  /// Widget for error handling in release mode
  final WidgetBuilder? releaseErrorBuilder;

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      final WidgetBuilder? _releaseErrorBuilder = releaseErrorBuilder;
      if (_releaseErrorBuilder != null) {
        return _releaseErrorBuilder(context);
      }

      return const _ReleaseErrorWidget();
    }

    final ErrorWidgetBuilder? _errorBuilder = errorBuilder;
    if (_errorBuilder != null) {
      return _errorBuilder(context, errorDetails);
    }

    return _ErrorWidget(errorDetails: errorDetails);
  }
}

class _ReleaseErrorWidget extends StatelessWidget {
  const _ReleaseErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Something went wrong'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => context.reloadWidget(),
                child: const Text('Reload application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key, required this.errorDetails}) : super(key: key);

  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () => context.reloadWidget(),
                child: const Text('Reload Widgets'),
              ),
            ),
            Text('Library: ${errorDetails.toStringShort()}'),
            const Divider(),
            Text('DiagnosticsNode: ${errorDetails.context?.toDescription()}'),
            const Divider(),
            Text('ErrorDetails: ${_stringify(errorDetails.exception)}'),
            const Divider(),
            Text('StackTrace: ${errorDetails.stack.toString()}'),
          ],
        ),
      ),
    );
  }

  String _stringify(Object exception) {
    try {
      return exception.toString();
    } catch (e) {
      // intentionally left empty.
    }
    return 'Error';
  }
}
