# system_proxy

Get the current default HTTP proxy settings.

## Getting Started

pubspec.yaml

```buildoutcfg
dependencies:
  system_proxy:
    git: https://github.com/fenrir-cd/flutter_system_proxy.git
```

### Example

```dart
String? proxy = await SystemProxy.proxySettings; // the value likes: "example.com:8080"
```

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemProxy.setupGlobalHttpProxy();
  runApp(const MyApp());
}
```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

