library size_ranged_image_compressor;

import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SizeRangedImageCompressor {
  /// Compresses a single image file to fit within a specified size range.
  ///
  /// [file] The original image file to be compressed. Must be a valid image file.
  /// [minimum] The minimum allowed file size in bytes. The function will
  /// attempt to keep the file size above this value. Must be greater than 0
  /// and less than [maximum].
  /// [maximum] The maximum allowed file size in bytes. The function will
  /// compress the image to stay below this value. Must be greater than [minimum].
  ///
  /// Typical usage:
  /// ```dart
  /// var result = await ImageCompressor.compressSingleFileWithCustomSize(
  ///   myImageFile,
  ///   minimum: 50 * 1024,  // 50 KB
  ///   maximum: 200 * 1024, // 200 KB
  /// );
  /// ```
  ///
  /// Returns an [Either] containing either an error message (String) if
  /// compression fails, or the compressed [File] if successful.
  static Future<Either<String, File>> compressSingleFileWithCustomSize(
    File file, {
    required int minimum,
    required int maximum,
    int qualityStep = 2,
  }) async {
    // Validate that maximum is not less than minimum
    if (maximum < minimum) {
      throw ArgumentError(
          'Maximum size must be greater than or equal to minimum size');
    }
    var fileSize = await file.length(); // original file size

    if (fileSize <= maximum && fileSize >= minimum) {
      return right(file); // File already within range
    }

    if (fileSize < minimum) {
      return left("File is smaller than the minimum size requirement");
    }

    Uint8List? resized = await FlutterImageCompress.compressWithFile(file.path);

    if (resized == null) {
      return left("Compression failed");
    }

    File resizedFile = await file.writeAsBytes(resized);

    fileSize = resizedFile.lengthSync(); // Get new file size after resizing

    if (fileSize <= maximum && fileSize >= minimum) {
      return right(resizedFile); // File is now within range after resizing
    }

    // Step 2: Adjust Quality
    var quality = 90; // Start quality at 90%
    Uint8List? lastValidCompressed;

    while (quality > 0) {
      Uint8List? compressed = await FlutterImageCompress.compressWithFile(
        resizedFile.path,
        quality: quality,
      );

      if (compressed == null) {
        return left("Compression failed");
      }

      int compressedSize = compressed.length;

      if (compressedSize <= maximum && compressedSize >= minimum) {
        resizedFile = await resizedFile.writeAsBytes(compressed);
        return right(resizedFile); // File is now within range after compression
      }

      // Save this as a valid compression if it's smaller than max but larger than min
      if (compressedSize <= maximum && compressedSize >= minimum) {
        lastValidCompressed = compressed;
      }

      if (compressedSize < minimum && lastValidCompressed != null) {
        resizedFile = await resizedFile.writeAsBytes(lastValidCompressed);
        return right(resizedFile); // Return the last valid compression
      }

      quality -= qualityStep;
    }

    if (lastValidCompressed != null) {
      resizedFile = await resizedFile.writeAsBytes(lastValidCompressed);
      return right(resizedFile);
    }

    return left("Unable to compress file to desired size range");
  }
}
