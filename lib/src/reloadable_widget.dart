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
    context.findAncestorStateOfType<_ReloadableWidgetState>()?.reloadWidget();
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
