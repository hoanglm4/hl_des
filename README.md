# hl_des

Flutter DES encryption and decryption.

Supported: DES/CBC/PKCS7Padding

## Getting Started

### Add dependency

```yaml
dependencies:
  hl_des: ^2.0.2  #latest version
```

### Example

```dart
import 'package:hl_des/hl_des.dart';

void example() async {
  const string = "Java, android, ios, get the same result by DES encryption and decryption."; // base64
  const key = "xxx="; // base64
  const iv = "xxx="; // base64

  decrypted = await HlDes.desDecrypt(data: string, iv: iv, key: key);
  print("decrypted = $decrypted");

  final encrypted = await HlDes.desEncrypt(data: decrypted, iv: iv, key: key);
  print("encrypted = $encrypted");
}
```

