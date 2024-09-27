import 'package:beat/api/tracks.dart';
import 'package:beat/models.dart';
import 'package:beat/screens/home/tab_title.dart';
import 'package:beat/widgets/track_item.dart';
import 'package:flutter/material.dart';

class TopTab extends StatefulWidget {
  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  late Future<List<Track>> _topFuture;

  @override
  void initState() {
    super.initState();
    _topFuture = fetchTop(); // Inicialize o Future aqui
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Track>>(
      future: _topFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum dado disponível'));
        } else {
          final top = snapshot.data!;

          // Filtrar músicas com previewUrl e sem previewUrl
          final tracksWithPreviewUrl =
              top.where((track) => track.previewUrl != null).toList();
          final tracksWithoutPreviewUrl =
              top.where((track) => track.previewUrl == null).toList();

          // Combinar as listas, colocando as músicas com previewUrl primeiro
          final sortedTracks = [
            ...tracksWithPreviewUrl,
            ...tracksWithoutPreviewUrl
          ];

          return ListView(
            children: <Widget>[
              const TabTitle(title: 'Fresh Hits'),
              for (final track in sortedTracks)
                TrackItem(
                  track: track,
                  tracks: top,
                ),
            ],
          );
        }
      },
    );
  }
}
