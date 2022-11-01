import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidgetBuilder;

part '_app_runner.dart';
part 'error_handler_widget.dart';
part 'models.dart';
part 'reloadable_widget.dart';

/// Starts the zone and attaches the app to the screen.
///
/// Calling [appRunner] again will detach the previous root widget from the screen and pin this widget in its place, creating a new zone.
/// The new widget tree is compared to the previous widget tree, and any differences are applied to the underlying visualization tree,
/// similar to what happens when [StatefulWidget] is rebuilt after calling [State.setState].
void appRunner(RunnerConfiguration config) => _AppRunner.run(config);

/// Reloads widgets when [reloadWidget] is called.
/// Reloads occurs by changing [UniqueKey].
void reloadWidget(BuildContext context) => context.reloadWidget();
