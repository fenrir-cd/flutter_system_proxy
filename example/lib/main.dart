import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_proxy/system_proxy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemProxy.setupGlobalHttpProxy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _proxy = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String proxy;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      proxy = await SystemProxy.proxySettings ?? 'Unknown';
    } on PlatformException {
      proxy = 'Failed to get proxy.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _proxy = proxy;
    });
  }

  void _test(BuildContext context) async {
    var httpClient = HttpClient();
    String message;
    try {
      var requet =
          await httpClient.getUrl(Uri.parse('https://www.example.com'));
      var response = await requet.close();
      message = 'Stutas Code: ${response.statusCode}';
    } catch (e) {
      message = e.toString();
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Proxy: $_proxy\n'),
              Builder(builder: (context) {
                return MaterialButton(
                  child: const Text('Test'),
                  onPressed: () => _test(context),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
