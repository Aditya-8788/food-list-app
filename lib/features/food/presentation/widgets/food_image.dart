import 'package:flutter/material.dart';

/// Dish photo from [url], with a tinted placeholder while loading,
/// when no URL is set, or when the image fails to load.
class FoodImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final double iconSize;

  const FoodImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 14,
    this.iconSize = 26,
  });

  /// True when [url] looks like something [Image.network] can load.
  static bool hasImage(String url) {
    final uri = Uri.tryParse(url.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(
      width: width,
      height: height,
      iconSize: iconSize,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: !hasImage(url)
          ? placeholder
          : Image.network(
              url.trim(),
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : placeholder,
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double iconSize;

  const _Placeholder({this.width, this.height, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: width,
      height: height,
      color: primary.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Icon(Icons.fastfood_rounded, color: primary, size: iconSize),
    );
  }
}
