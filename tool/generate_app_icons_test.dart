import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_juros/core/theme/app_logo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('renders launcher icons from the shared app logo', () async {
    const androidSizes = {
      'mipmap-mdpi': 48,
      'mipmap-hdpi': 72,
      'mipmap-xhdpi': 96,
      'mipmap-xxhdpi': 144,
      'mipmap-xxxhdpi': 192,
    };

    for (final entry in androidSizes.entries) {
      await _renderIcon(
        'android/app/src/main/res/${entry.key}/ic_launcher.png',
        entry.value,
      );
    }

    final manifestFile = File(
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
    );
    final manifest =
        jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
    final images = manifest['images'] as List<dynamic>;
    for (final image in images.cast<Map<String, dynamic>>()) {
      final logicalSize = double.parse(
        (image['size'] as String).split('x').first,
      );
      final scale = double.parse((image['scale'] as String).replaceAll('x', ''));
      final pixels = (logicalSize * scale).round();
      await _renderIcon(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/${image['filename']}',
        pixels,
      );
    }
  });
}

Future<void> _renderIcon(String path, int pixels) async {
  final recorder = ui.PictureRecorder();
  const painter = AppLogoPainter();
  painter.paint(
    ui.Canvas(recorder),
    ui.Size(pixels.toDouble(), pixels.toDouble()),
  );
  final image = await recorder.endRecording().toImage(pixels, pixels);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  await File(path).writeAsBytes(data!.buffer.asUint8List());
  image.dispose();
}