import 'package:beat/models.dart';
import 'package:beat/screens/album/album_screen.dart';
import 'package:beat/screens/artist/artist_screen.dart';
import 'package:beat/screens/play/play_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static MaterialPageRoute<void> play(Track initialTrack, List<Track> tracks) {
    final tracksWithPreview = tracks.where((t) => t.previewUrl != null).toList();

    return MaterialPageRoute(
      builder: (BuildContext context) => PlayScreen(initialTrack: initialTrack, tracks: tracksWithPreview),
    );
  }

  static MaterialPageRoute<void> artist({required Artist artist}) {
    return MaterialPageRoute(
      builder: (BuildContext context) => ArtistScreen(artist: artist),
    );
  }

  static MaterialPageRoute<void> album({required String albumId, required String artistName}) {
    return MaterialPageRoute(
      builder: (BuildContext context) => AlbumScreen(albumId: albumId, artistName: artistName),
    );
  }
}
