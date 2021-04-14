import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hl_des/hl_des.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _decrypted = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String decrypted;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      const string = "Java, android, ios, get the same result by DES encryption and decryption."; // base64
      const key = "xxx="; // base64
      const iv = "xxx="; // base64

      decrypted = await HlDes.desDecrypt(data: string, iv: iv, key: key);
      print("decrypted = $decrypted");

      final encrypted = await HlDes.desEncrypt(data: decrypted, iv: iv, key: key);
      print("encrypted = $encrypted");
    } on PlatformException {
      decrypted = 'Failed to decrypted';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _decrypted = decrypted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_decrypted\n'),
        ),
      ),
    );
  }
}
