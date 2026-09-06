# dartnative_device_info

Get current device information for DartNative applications on iOS and Android without any Flutter dependencies.

## Usage

```dart
import 'package:dartnative_device_info/dartnative_device_info.dart';

void main() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Device: ${iosInfo.name}, iOS ${iosInfo.systemVersion}');
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Device: ${androidInfo.model}, Android ${androidInfo.version.release}');
  }
}
```
