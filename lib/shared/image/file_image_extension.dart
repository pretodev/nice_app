import 'dart:convert';
import 'dart:io';

const _imageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'heic',
];

extension FileImageExtension on File {
  Future<String> toImageBase64() async {
    final extension = path.split('.').last;
    if (!_imageExtensions.contains(extension)) {
      throw const FormatException(
        'Only JPEG, PNG, and HEIC images are supported',
      );
    }

    final bytes = await readAsBytes();
    final base64String = base64Encode(bytes);
    return 'data:image/${path.split('.').last};base64,$base64String';
  }
}
