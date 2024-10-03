# size_ranged_image_compressor

A Dart package for compressing image files to fit within a specified size range, while maintaining the best possible quality.
Features

<ul>
  <li>Compress images to fit within a specified size range (minimum and maximum file size) </li>
  <li>Maintains the highest possible quality while meeting size constraints</li>
  <li>Handles both resizing and quality adjustment for optimal results</li>
  <li>Provides clear error messages if compression fails</li>
</ul>

<h2>Installation</h2>

<p>Add this to your package's <code>pubspec.yaml</code> file:</p>

<pre><code>dependencies:
  size_ranged_image_compressor: ^1.0.0
</code></pre>

<p>Then run:</p>

<pre><code>$ flutter pub get
</code></pre>

<h2>Usage</h2>

<p>Here's a simple example of how to use the <code>size_ranged_image_compressor</code>:</p>

<pre><code>import 'dart:io';
import 'package:size_ranged_image_compressor/size_ranged_image_compressor.dart';

void main() async {
  File imageFile = File('path/to/your/image.jpg');

  var result = await ImageCompressor.compressSingleFileWithCustomSize(
    imageFile,
    minimum: 50 * 1024,  // 50 KB
    maximum: 200 * 1024, // 200 KB
  );

  result.fold(
    (error) => print('Compression failed: $error'),
    (compressedFile) => print('Compressed file size: ${compressedFile.lengthSync()} bytes'),
  );
}
</code></pre>

<p>This example demonstrates how to compress an image file to a size between 50 KB and 200 KB.</p>

<h2>API Reference</h2>

<h3>ImageCompressor.compressSingleFileWithCustomSize</h3>

<pre><code>static Future<Either<String, File>> compressSingleFileWithCustomSize(
  File file, {
  required int minimum,
  required int maximum,
  int qualityStep = 2,
})
</code></pre>

<p>Compresses a single image file to fit within a specified size range.</p>

<h4>Parameters:</h4>

<ul>
  <li><strong>file</strong>: The original image file to be compressed. Must be a valid image file.</li>
  <li><strong>minimum</strong>: The minimum allowed file size in bytes. Must be greater than 0 and less than or equal to maximum.</li>
  <li><strong>maximum</strong>: The maximum allowed file size in bytes. Must be greater than or equal to minimum.</li>
  <li><strong>qualityStep</strong>: The step size for reducing quality during compression. Default is 2. Lower values result in more gradual quality reduction.</li>
</ul>

<h4>Returns:</h4>

<p>An <code>Either</code> containing either an error message (<code>String</code>) if compression fails, or the compressed <code>File</code> if successful.</p>

<h4>Throws:</h4>

<p><code>ArgumentError</code> if maximum is less than minimum.</p>

<h2>Error Handling</h2>

<p>The package uses the <code>Either</code> type for error handling. If compression fails, it will return a <code>Left</code> with an error message. If successful, it will return a <code>Right</code> with the compressed <code>File</code>.</p>

<h4>Common error messages include:</h4>

<ul>
  <li>"File is smaller than the minimum size requirement"</li>
  <li>"Compression failed"</li>
  <li>"Unable to compress file to desired size range"</li>
</ul>

<h2>Contributing</h2>

<p>Contributions are welcome! Please feel free to submit a Pull Request.</p>

<h2>License</h2>

<p>This project is licensed under the MIT License - see the LICENSE file for details.</p>
