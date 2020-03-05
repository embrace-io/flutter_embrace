[![pub package](https://img.shields.io/pub/v/flutter_embrace.svg)](https://pub.dev/packages/flutter_embrace)
[![apidoc](https://img.shields.io/pub/v/flutter_embrace.svg?label=apidoc)](https://pub.dev/documentation/flutter_embrace/latest/)

# Embrace for Flutter


## Usage

```dart
Embrace.initialize(); // for http logging

MaterialApp(
  navigatorObservers: [EmbraceRouteObserver()], // for view logging
);
```

More APIs for flutter: [![apidoc](https://img.shields.io/pub/v/flutter_embrace.svg?label=apidoc)](https://pub.dev/documentation/flutter_embrace/latest/flutter_embrace/Embrace-class.html)

## Installation

pubspec.yaml

```yaml
dependencies:
  flutter_embrace:
    git:
      url: https://github.com/yongjhih/flutter_embrace.git
```

App.kt

```kt
class App : io.flutter.app.FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Embrace.getInstance().start(this)
    }
}
```

AndroidManifest.xml

```xml
<manifest>
    <application
        android:name=".App">
    </application>
</manifest>
```

build.gradle

```gradle
dependencies {
    implementation "embrace-io:embrace-android-sdk:4.1.0"
}
```

## Test / Code Coverage

```sh
./coverage.sh && ./coverage.sh && ./coverage.sh --report
```

