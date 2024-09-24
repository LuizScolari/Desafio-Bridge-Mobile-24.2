import 'package:beat/utils/colors.dart';
import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  final String imageUrl;
  final int size;
  final bool enabled;

  const RoundImage({
    Key? key,
    required this.imageUrl,
    required this.size,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        imageUrl,
        width: size.toDouble(),
        height: size.toDouble(),
        color: enabled ? null : BeatColors.disabledColor,
        colorBlendMode: enabled ? null : BlendMode.saturation,
      ),
    );
  }
}
