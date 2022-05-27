## 2.1.0

* **BREAKING**: Note, starting with version 2.1.0, Flutter 3.0.0+ is used by default. If you need to use a Flutter version lower than 3.0.0, then use package version 2.0.0 and below.
* Fix bang operator on `WidgetsBinding.instance`.

## 2.0.0

* **BREAKING**: feat: Add `AppBuilder` widget
* **BREAKING**: WidgetConfiguration:
    * `WidgetConfiguration.app` removed, use `child` with `AppBuilder`
    * `WidgetConfiguration.splash` removed, use `child` with `AppBuilder`
* **BREAKING**: RunnerConfiguration:
    * `RunnerConfiguration.preInitializeFunctions` removed, use `AppBuilder.preInitializeFunctions`
    * `RunnerConfiguration` has two constructors, default and guarded

## 1.0.1-1.0.2

* Fix doc

## 1.0.0

* Initial stable release.
