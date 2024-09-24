import 'package:flutter/material.dart';

const double _kDefaultGradientOffset = 50.0;

class ImageGradientBackground extends StatelessWidget {
  final Widget? foreground;
  final String backgroundUrl;
  final double gradientOffset;

  const ImageGradientBackground({
    Key? key,
    required this.backgroundUrl,
    this.foreground,
    this.gradientOffset = _kDefaultGradientOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = constraints.maxWidth;
        return Stack(
          children: [
            Image.network(
              backgroundUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(top: imageSize - gradientOffset),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    height: gradientOffset,
                  ),
                  SizedBox(height: gradientOffset / 3),
                  if (foreground != null)
                    Material(
                      type: MaterialType.transparency,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: gradientOffset / 3,
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        child: foreground!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
