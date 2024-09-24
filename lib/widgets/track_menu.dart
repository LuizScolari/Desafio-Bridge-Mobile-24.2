import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:beat/utils/colors.dart';
import 'package:flutter/material.dart';

const _kAlbumSentinel = 'album';

class TrackMenu extends StatelessWidget {
  final Track track;

  const TrackMenu({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (id) {
        if (id == _kAlbumSentinel) {
          Navigator.push(context, Routes.album(albumId: track.album.id, artistName: track.artists.first.name));
        } else {
          final artist = track.artists.firstWhere((a) => a.id == id, orElse: () => Artist(id: 'invalid', name: 'Unknown'));
          if (artist.id != 'invalid') {
            Navigator.push(context, Routes.artist(artist: artist));
          }
        }
      },
      color: Colors.white,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: _kAlbumSentinel,
            child: Text(
              'Ver álbum',
              style: TextStyle(color: BeatColors.darkGrey),
            ),
          ),
          ...track.artists.map((artist) {
            return PopupMenuItem(
              value: artist.id,
              child: Text(
                'Ver ${artist.name}',
                style: const TextStyle(color: BeatColors.darkGrey),
              ),
            );
          }).toList(),
        ];
      },
    );
  }
}
