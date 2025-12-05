import 'package:flutter/material.dart';

Image buildRecipeImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  final isNetwork = path.startsWith('http');

  if (isNetwork) {
    return Image.network(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, _, __) => _fallbackPlaceholder(width, height),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _loadingPlaceholder(progress, width, height);
      },
    );
  }

  return Image.asset(
    path,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, _, __) => _fallbackPlaceholder(width, height),
  );
}

Widget _fallbackPlaceholder(double? width, double? height) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey.shade300,
    alignment: Alignment.center,
    child: const Icon(Icons.image_not_supported),
  );
}

Widget _loadingPlaceholder(
  ImageChunkEvent progress,
  double? width,
  double? height,
) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: CircularProgressIndicator.adaptive(
      value: progress.expectedTotalBytes != null
          ? progress.cumulativeBytesLoaded /
                progress.expectedTotalBytes! // coverage:ignore-line
          : null,
    ),
  );
}
