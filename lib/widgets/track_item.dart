import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:beat/utils/colors.dart';
import 'package:beat/widgets/favorite_button.dart';
import 'package:beat/widgets/round_image.dart';
import 'package:beat/widgets/track_menu.dart';
import 'package:flutter/material.dart';

class TrackItem extends StatelessWidget {
  final Track track;
  final List<Track> tracks;
  final bool liked;

  const TrackItem({
    Key? key,
    required this.track,
    required this.tracks,
    this.liked = false,
  }) : super(key: key);

  void onPressed(BuildContext context) {
    Navigator.push(context, Routes.play(track, tracks));
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = track.previewUrl != null;

    return InkWell(
      onTap: enabled ? () => onPressed(context) : null,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          top: 12,
          bottom: 12,
        ),
        child: Row(
          children: <Widget>[
            RoundImage(
              size: 48,
              imageUrl: track.album.image ?? 'https://via.placeholder.com/48', // Fallback URL
              enabled: enabled,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    track.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: enabled ? Colors.white : BeatColors.disabledColor,
                    ),
                  ),
                  Text(
                    track.artistsNames,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: enabled ? const Color(0xFF7B7B7B) : BeatColors.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FavoriteButton(
              track: track,
              enabled: enabled,
            ),
            TrackMenu(track: track),
          ],
        ),
      ),
    );
  }
}
