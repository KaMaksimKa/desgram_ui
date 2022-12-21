import 'package:desgram_ui/domain/models/image_with_url_model.dart';

class ImageContentHelper {
  static ImageWithUrlModel chooseImage(
      {required List<ImageWithUrlModel> images,
      ImageQuality quality = ImageQuality.normal}) {
    images.sort((a, b) => a.height.compareTo(b.height));
    switch (quality) {
      case ImageQuality.low:
        return images.first;
      case ImageQuality.normal:
        return images[images.length ~/ 2];
      case ImageQuality.high:
        return images.last;
    }
  }
}

enum ImageQuality { low, normal, high }
