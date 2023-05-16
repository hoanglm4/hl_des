
import 'dart:async';

import 'package:flutter/services.dart';

class HlDes {
  static const MethodChannel _channel =
      const MethodChannel('hl_des');

  static FutureOr<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static FutureOr<String> desDecrypt({required String data, required String key, required String iv}) async {
    final params = <String, dynamic>{"key": key, "iv": iv, "data": data};
    final String decrypted = await _channel.invokeMethod('desDecrypt', params);
    return decrypted;
  }

  static FutureOr<String> desEncrypt({required String data, required String key, required String iv}) async {
    final params = <String, dynamic>{"key": key, "iv": iv, "data": data};
    final String decrypted = await _channel.invokeMethod('desEncrypt', params);
    return decrypted;
  }
}
