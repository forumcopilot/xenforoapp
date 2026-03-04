import 'dart:io';

bool get isPasskeySupportedByPlatform => Platform.isIOS || Platform.isAndroid;
bool get isIOSPlatform => Platform.isIOS;
bool get isAndroidPlatform => Platform.isAndroid;
