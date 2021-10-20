import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class SystemProxy {
  static const MethodChannel _channel = MethodChannel('system_proxy');

  static Future<String?> get proxySettings async {
    final String? settings = await _channel.invokeMethod('getProxySettings');
    return settings;
  }

  static Future<void> setupGlobalHttpProxy() async {
    final proxy = await proxySettings;
    if (proxy != null) {
      HttpOverrides.global = _SystemProxyHttpOverrides(proxy);
    }
  }
}

class _SystemProxyHttpOverrides extends HttpOverrides {
  final String _proxy;

  _SystemProxyHttpOverrides(this._proxy);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = ((_, __, ___) => true)
      ..findProxy = (_) => 'PROXY $_proxy';
  }
}
