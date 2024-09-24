import 'package:beat/api/artists.dart';
import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:beat/widgets/album_carousel.dart';
import 'package:beat/widgets/beat_button.dart';
import 'package:beat/widgets/beat_scaffold.dart';
import 'package:beat/widgets/image_gradient_background.dart';
import 'package:beat/widgets/track_item.dart';
import 'package:flutter/material.dart';

class ArtistScreen extends StatefulWidget {
  final Artist artist;

  const ArtistScreen({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool _loading = true;
  FullArtist? _artist;

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  Future<void> _loadArtist() async {
    try {
      final artist = await fetchArtist(widget.artist.id);
      setState(() {
        _loading = false;
        _artist = artist;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _loading = false;
        _artist = null;
      });
    }
  }

  void _onPlayPressed(BuildContext context, List<Track> tracks) {
    Navigator.push(
      context,
      Routes.play(tracks.first, tracks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BeatScaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final artist = _artist;
    if (artist == null) {
      return const Center(child: Text('Artista não encontrado'));
    }

    final enabledTracks = artist.topTracks.where((track) => track.previewUrl != null).toList();

    return ListView(
      children: <Widget>[
        ImageGradientBackground(
          backgroundUrl: artist.image,
          foreground: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  artist.name,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '1.000 seguidores',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7B7B7B),
                  ),
                ),
                const SizedBox(height: 16),
                BeatButton(
                  onPressed: enabledTracks.isNotEmpty ? () => _onPlayPressed(context, enabledTracks) : null,
                  child: const Text('TOCAR'),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 16),
          child: Text(
            'Mais ouvidas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...artist.topTracks.map((track) => TrackItem(
              track: track,
              tracks: artist.topTracks,
            )),
        if (artist.albums.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(left: 24, top: 16),
            child: Text(
              'Discografia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AlbumCarousel(albums: artist.albums, artist: artist),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
