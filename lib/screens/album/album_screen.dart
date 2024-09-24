import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:beat/widgets/beat_scaffold.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatefulWidget {
  final String albumId;
  final String artistName;

  const AlbumScreen({
    Key? key,
    required this.albumId,
    required this.artistName,
  }) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  bool _loading = true;
  FullAlbum? _album;

  @override
  void initState() {
    super.initState();
    _loadAlbum();
  }

  Future<void> _loadAlbum() async {
    // criar função para carregar o álbum aqui
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
    // criar layout da tela aqui

    return const Center(
      child: Text('Tela de álbum'),
    );
  }
}
