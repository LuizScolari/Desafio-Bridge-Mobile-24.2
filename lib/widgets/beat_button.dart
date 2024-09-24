import 'package:beat/utils/colors.dart';
import 'package:flutter/material.dart';

class BeatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const BeatButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: BeatColors.black80,
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
