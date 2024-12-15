import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

List<double> transformImage(File imageFile) {
  // Read the image file
  Uint8List imageBytes = imageFile.readAsBytesSync();
  img.Image? image = img.decodeImage(imageBytes);

  if (image == null) {
    throw Exception('Failed to decode image');
  }

  // Resize the image to 224x224
  img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

  // Convert the image to a list of pixel values
  List<double> pixelValues = [];
  for (int y = 0; y < resizedImage.height; y++) {
    for (int x = 0; x < resizedImage.width; x++) {
      img.Pixel pixel = resizedImage.getPixel(x, y);
      double r = pixel.r.toDouble() / 255.0;
      double g = pixel.g.toDouble() / 255.0;
      double b = pixel.b.toDouble() / 255.0;

      // Normalize the values
      r = (r - 0.5) / 0.5;
      g = (g - 0.5) / 0.5;
      b = (b - 0.5) / 0.5;

      pixelValues.addAll([r, g, b]);
    }
  }

  return pixelValues;
}

