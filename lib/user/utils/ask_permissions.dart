import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<bool> askPermissions() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final sdk = androidInfo.version.sdkInt;

  bool cameraGranted = false;
  bool galleryGranted = false;

  // --- Permiso de cámara ---
  final cameraStatus = await Permission.camera.request();
  cameraGranted = cameraStatus.isGranted;

  // --- Permisos de galería según versión de Android ---
  if (sdk >= 33) {
    // Android 13+ usa READ_MEDIA_IMAGES
    final photosStatus = await Permission.photos.request();
    galleryGranted = photosStatus.isGranted;
  } else {
    // Android 12 o menor usa READ_EXTERNAL_STORAGE
    final storageStatus = await Permission.storage.request();
    galleryGranted = storageStatus.isGranted;
  }

  return cameraGranted && galleryGranted;
}