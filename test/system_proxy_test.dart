import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system_proxy/system_proxy.dart';

void main() {
  const MethodChannel channel = MethodChannel('system_proxy');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getProxySettings', () async {
    expect(await SystemProxy.proxySettings, '42');
  });
}
