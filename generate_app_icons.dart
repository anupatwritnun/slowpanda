/// Script to generate iOS app icons from Logo.png
/// Run with: dart generate_app_icons.dart

import 'dart:io';
import 'package:image/image.dart';

void main() async {
  // Original logo path
  final logoPath = 'C:\\Users\\DELL\\Downloads\\KalmFu Panda\\Logo.png';
  final outputDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/';

  // Required iOS icon sizes
  final iconSizes = {
    'Icon-App-1024x1024@1x.png': 1024,
    'Icon-App-20x20@1x.png': 20,
    'Icon-App-20x20@2x.png': 40,
    'Icon-App-20x20@3x.png': 60,
    'Icon-App-29x29@1x.png': 29,
    'Icon-App-29x29@2x.png': 58,
    'Icon-App-29x29@3x.png': 87,
    'Icon-App-40x40@1x.png': 40,
    'Icon-App-40x40@2x.png': 80,
    'Icon-App-40x40@3x.png': 120,
    'Icon-App-60x60@2x.png': 120,
    'Icon-App-60x60@3x.png': 180,
    'Icon-App-76x76@1x.png': 76,
    'Icon-App-76x76@2x.png': 152,
    'Icon-App-83.5x83.5@2x.png': 167,
  };

  print('Reading logo from: $logoPath');

  try {
    // Read original logo
    final originalImage = decodeImage(File(logoPath).readAsBytesSync());

    if (originalImage == null) {
      print('Error: Could not read logo image');
      return;
    }

    print('Original image size: ${originalImage.width}x${originalImage.height}');

    // Generate each icon size
    for (var entry in iconSizes.entries) {
      final filename = entry.key;
      final size = entry.value;

      // Resize image
      final resized = copyResize(
        originalImage,
        width: size,
        height: size,
        interpolation: Interpolation.cubic,
      );

      // Save to file
      final outputPath = '$outputDir$filename';
      File(outputPath).writeAsBytesSync(encodePng(resized));
      print('Generated: $filename (${size}x$size)');
    }

    print('\nAll icons generated successfully!');
    print('Location: $outputDir');

  } catch (e) {
    print('Error: $e');
  }
}
