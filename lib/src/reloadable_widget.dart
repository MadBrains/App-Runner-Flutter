part of 'app_runner.dart';

/// {@template ReloadableWidget}
/// Reloads widgets when [reloadWidget] is called.
/// Reloads occurs by changing [UniqueKey].
///
/// Accepts a [child] which will be reloaded.
/// {@endtemplate}
class ReloadableWidget extends StatefulWidget {
  /// {@macro ReloadableWidget}
  const ReloadableWidget({required this.builder});

  /// Called to obtain the child widget.
  final WidgetBuilder builder;

  @override
  _ReloadableWidgetState createState() => _ReloadableWidgetState();

  /// Reloads widgets when [reloadWidget] is called.
  /// Reloads occurs by changing [UniqueKey].
  static void reloadWidget(BuildContext context) {
    try {
      context.findAncestorStateOfType<_ReloadableWidgetState>()?.reloadWidget();
    } catch (_) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }
}

class _ReloadableWidgetState extends State<ReloadableWidget> {
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.builder(context),
    );
  }

  void reloadWidget() {
    setState(() {
      _key = UniqueKey();
    });
  }
}

/// Extension for ReloadableWidget on BuildContext.
///
/// {@macro ReloadableWidget}
extension ReloadableX on BuildContext {
  /// Reloads widgets when [reloadWidget] is called.
  /// Reloads occurs by changing [UniqueKey].
  void reloadWidget() => ReloadableWidget.reloadWidget(this);
}
