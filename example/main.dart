import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:size_ranged_image_compressor/src/size_ranged_image_compressor.dart';

void main() async {
  // Step 1: Get the image file
  // In a real application, you might get this from user input or another source
  File imageFile = File('path/to/your/image.jpg');

  // Step 2: Define your desired size range
  int minimumSize = 50 * 1024; // 50 KB
  int maximumSize = 200 * 1024; // 200 KB

  // Step 3: Use the package to compress the image
  var result = await SizeRangedImageCompressor.compressSingleFileWithCustomSize(
    imageFile,
    minimum: minimumSize,
    maximum: maximumSize,
  );

  // Step 4: Handle the result
  result.fold(
    (error) {
      // Handle error
      if (kDebugMode) {
        print('Compression failed: $error');
      }
    },
    (compressedFile) {
      // Handle success
      if (kDebugMode) {
        print('Compression successful');
      }
      if (kDebugMode) {
        print('Compressed file path: ${compressedFile.path}');
      }
      if (kDebugMode) {
        print('Compressed file size: ${compressedFile.lengthSync()} bytes');
      }
    },
  );
}
