/// Generate PWA icons from Logo.png
/// Run with: dart run generate_pwa_icons.dart

import 'dart:io';
import 'package:image/image.dart';

void main() {
  final logoPath = 'C:\\Users\\DELL\\Downloads\\KalmFu Panda\\Logo.png';
  final iconsDir = 'web/icons/';

  // PWA icon sizes
  final iconSizes = [72, 96, 128, 144, 152, 192, 384, 512];

  print('Reading logo from: $logoPath');

  try {
    final originalImage = decodeImage(File(logoPath).readAsBytesSync());

    if (originalImage == null) {
      print('Error: Could not read logo image');
      return;
    }

    print('Original image size: ${originalImage.width}x${originalImage.height}');

    // Ensure icons directory exists
    Directory(iconsDir).createSync(recursive: true);

    // Generate each icon size
    for (final size in iconSizes) {
      final resized = copyResize(
        originalImage,
        width: size,
        height: size,
        interpolation: Interpolation.cubic,
      );

      final filename = 'icon-${size}x$size.png';
      final outputPath = '$iconsDir$filename';

      File(outputPath).writeAsBytesSync(encodePng(resized));
      print('Generated: $filename (${size}x$size)');
    }

    // Also generate favicon.png (16x16)
    final favicon = copyResize(
      originalImage,
      width: 16,
      height: 16,
      interpolation: Interpolation.cubic,
    );
    File('web/favicon.png').writeAsBytesSync(encodePng(favicon));
    print('Generated: favicon.png (16x16)');

    print('\nAll PWA icons generated successfully!');
    print('Location: $iconsDir');

  } catch (e) {
    print('Error: $e');
  }
}
