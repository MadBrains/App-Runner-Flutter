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
