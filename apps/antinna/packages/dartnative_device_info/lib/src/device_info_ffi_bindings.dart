import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef _GetDeviceInfoC = Pointer<Utf8> Function();
typedef _GetDeviceInfoDart = Pointer<Utf8> Function();

typedef _FreeDeviceInfoStringC = Void Function(Pointer<Utf8>);
typedef _FreeDeviceInfoStringDart = void Function(Pointer<Utf8>);

class DeviceInfoFFIBindings {
  static late final _GetDeviceInfoDart _getIosInfo;
  static late final _GetDeviceInfoDart _getAndroidInfo;
  static late final _FreeDeviceInfoStringDart _freeString;
  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static void loadSymbols() {
    if (_loaded) return;
    if (!Platform.isIOS && !Platform.isAndroid) return;

    final DynamicLibrary lib = Platform.isAndroid
        ? DynamicLibrary.open('libdartnative_device_info.so')
        : DynamicLibrary.process();

    if (Platform.isIOS) {
      _getIosInfo = lib.lookupFunction<_GetDeviceInfoC, _GetDeviceInfoDart>(
          'DNDeviceInfoGetIosInfo');
    } else if (Platform.isAndroid) {
      _getAndroidInfo = lib.lookupFunction<_GetDeviceInfoC, _GetDeviceInfoDart>(
          'DNDeviceInfoGetAndroidInfo');
    }

    _freeString = lib.lookupFunction<_FreeDeviceInfoStringC,
        _FreeDeviceInfoStringDart>('DNDeviceInfoFreeString');
    _loaded = true;
  }

  static String? getIosInfoJson() {
    if (!_loaded || !Platform.isIOS) return null;
    final ptr = _getIosInfo();
    if (ptr == nullptr) return null;
    try {
      return ptr.toDartString();
    } finally {
      _freeString(ptr);
    }
  }

  static String? getAndroidInfoJson() {
    if (!_loaded || !Platform.isAndroid) return null;
    final ptr = _getAndroidInfo();
    if (ptr == nullptr) return null;
    try {
      return ptr.toDartString();
    } finally {
      _freeString(ptr);
    }
  }
}
