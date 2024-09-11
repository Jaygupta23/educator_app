import 'dart:io';
import 'package:archive/archive.dart';

void zipApkFile(String apkFilePath, String zipFilePath) {
  // Read the APK file
  final apkFile = File(apkFilePath);
  final apkBytes = apkFile.readAsBytesSync();

  // Create an archive and add the APK file
  final archive = Archive();
  archive.addFile(ArchiveFile('app-release.apk', apkBytes.length, apkBytes));

  // Encode the archive to a ZIP file
  final zipEncoder = ZipEncoder();
  final zipFile = File(zipFilePath);
  zipFile.writeAsBytesSync(zipEncoder.encode(archive)!);
}

void main() {
  zipApkFile(
      'C:\Users\OMR-06\Desktop\Flutter\Streaming_App\reelies\build\app\outputs\flutter-apk\app-release.apk',
      'output_zip_file.zip');
}
