import 'package:beat/business/favorites.dart';
import 'package:beat/models.dart';
import 'package:beat/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final Track track;
  final bool enabled;
  final Color activeColor;

  const FavoriteButton({
    Key? key,
    required this.track,
    this.enabled = true,
    this.activeColor = BeatColors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);
    final liked = favorites.contains(track);
    final editable = favorites.editable(track);

    return IconButton(
      onPressed: enabled && editable
          ? () {
              if (liked) {
                favorites.remove(track);
              } else {
                favorites.add(track);
              }
            }
          : null,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _buildChild(context, liked, !editable),
      ),
    );
  }

  Widget _buildChild(BuildContext context, bool liked, bool loading) {
    if (loading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    }

    return Image.asset(
      liked
          ? 'assets/icons/heart_filled.png'
          : 'assets/icons/heart_outline.png',
      color: enabled
          ? (liked ? activeColor : Colors.white)
          : BeatColors.disabledColor,
      width: 24,
      height: 24,
      key: Key(liked ? 'liked' : 'not_liked'),
    );
  }
}
