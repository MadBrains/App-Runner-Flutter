part of 'app_runner.dart';

const double _kMaxWidth = 100000.0;
const double _kMaxHeight = 100000.0;

/// {@template ErrorHandlerWidget}
/// Widget that catches and handles widget errors
/// {@endtemplate}
class ErrorHandlerWidget extends LeafRenderObjectWidget {
  /// {@macro ErrorHandlerWidget}
  ErrorHandlerWidget({
    required this.errorDetails,
    this.releaseErrorBuilder,
    this.errorBuilder,
  }) : super(key: UniqueKey());

  /// Error information provided to [FlutterExceptionHandler] callbacks.
  final FlutterErrorDetails errorDetails;

  /// Widget for error handling in debug and profile mode
  final ErrorRenderObjectBuilder? errorBuilder;

  /// Widget for error handling in release mode
  final RenderObjectBuilder? releaseErrorBuilder;

  @override
  RenderObject createRenderObject(BuildContext context) {
    if (kReleaseMode) {
      final RenderObjectBuilder? _releaseErrorBuilder = releaseErrorBuilder;
      if (_releaseErrorBuilder != null) {
        return _releaseErrorBuilder(context);
      }

      return _RenderReleaseErrorBox(context.reloadWidget);
    }

    final ErrorRenderObjectBuilder? _errorBuilder = errorBuilder;
    if (_errorBuilder != null) {
      return _errorBuilder(context, errorDetails);
    }

    return _RenderErrorBox(errorDetails, context.reloadWidget);
  }
}

class _RenderReleaseErrorBox extends RenderBox {
  _RenderReleaseErrorBox(this.onTap) {
    try {
      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(paragraphStyle);
      builder.pushStyle(textStyle);
      builder.addText('Something went wrong\n\nTap to reload application');
      _paragraph = builder.build();
    } catch (_) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }

  final ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );

  final ui.TextStyle textStyle = ui.TextStyle(
    fontSize: 18.0,
  );

  late final ui.Paragraph _paragraph;

  final VoidCallback onTap;

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _kMaxWidth;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _kMaxHeight;
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) {
    onTap();
    return true;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(const Size(_kMaxWidth, _kMaxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    try {
      context.canvas.drawRect(
        offset & size,
        Paint()..color = const ui.Color(0xEC2E2E2E),
      );

      _paragraph.layout(ui.ParagraphConstraints(width: size.width));
      context.canvas.drawParagraph(_paragraph, size.centerLeft(offset));
    } catch (_) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }
}

class _RenderErrorBox extends RenderBox {
  _RenderErrorBox(final FlutterErrorDetails errorDetails, this.onTap) {
    try {
      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(paragraphStyle);
      builder.pushStyle(textStyle);
      builder.addText('''
Library: ${errorDetails.toStringShort()}
DiagnosticsNode: ${errorDetails.context?.toDescription()}

ErrorDetails: ${_stringify(errorDetails.exception)}

StackTrace: \n${errorDetails.stack.toString()}
''');
      _paragraph = builder.build();
    } catch (_) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }

  final ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  );

  final ui.TextStyle textStyle = ui.TextStyle(
    fontSize: 14.0,
  );

  late final ui.Paragraph _paragraph;

  final VoidCallback onTap;

  String _stringify(Object exception) {
    try {
      return exception.toString();
    } catch (e) {
      // intentionally left empty.
    }
    return 'Error';
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _kMaxWidth;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _kMaxHeight;
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) {
    onTap();
    return true;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(const Size(_kMaxWidth, _kMaxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    try {
      context.canvas.drawRect(
        offset & size,
        Paint()..color = const ui.Color(0xEC2E2E2E),
      );

      _paragraph.layout(ui.ParagraphConstraints(width: size.width - 20));
      context.canvas.drawParagraph(_paragraph, offset + const Offset(10, 28));
    } catch (_) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }
}
