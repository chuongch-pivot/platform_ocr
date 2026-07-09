import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'darwin/platform_ocr_darwin.dart';
import 'windows/platform_ocr_windows.dart';

abstract class PlatformOcr {
  factory PlatformOcr() {
    if (Platform.isMacOS || Platform.isIOS) {
      return DarwinPlatformOcr();
    }

    if (Platform.isWindows) {
      return WindowsPlatformOcr();
    }

    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  Future<OcrResult> recognizeText(OcrSource source, {OcrOptions? options});

  void dispose();
}

class OcrOptions {
  const OcrOptions({this.recognitionLanguages});

  final List<OcrLanguage>? recognitionLanguages;
}

enum OcrLanguage {
  english('en-US'),
  simplifiedChinese('zh-Hans'),
  traditionalChinese('zh-Hant'),
  french('fr-FR'),
  german('de-DE'),
  italian('it-IT'),
  japanese('ja-JP'),
  korean('ko-KR'),
  portuguese('pt-PT'),
  russian('ru-RU'),
  spanish('es-ES');

  const OcrLanguage(this.code);

  final String code;
}

class OcrResult {
  final String text;
  final List<OcrLine> lines;

  OcrResult({required this.text, required this.lines});

  @override
  String toString() => text;
}

class OcrLine {
  final String text;
  final Rectangle boundingBox;

  OcrLine({required this.text, required this.boundingBox});
}

abstract class OcrSource {
  factory OcrSource.file(File file) = FileOcrSource;
  factory OcrSource.memory(Uint8List bytes) = MemoryOcrSource;
}

class FileOcrSource implements OcrSource {
  final File file;
  FileOcrSource(this.file);
}

class MemoryOcrSource implements OcrSource {
  final Uint8List bytes;
  MemoryOcrSource(this.bytes);
}
