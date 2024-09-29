import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:beat/widgets/beat_scaffold.dart';
import 'package:beat/widgets/image_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beat/widgets/favorite_button.dart';
import 'package:beat/widgets/track_menu.dart';

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
    try {
      final response = await http.get(
        Uri.parse(
            'https://caio-musicplayer.builtwithdark.com/albums/${widget.albumId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _album = FullAlbum.fromJson(data);
          _loading = false;
        });
      } else {
        throw Exception('Erro ao carregar o álbum');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
      body: _loading ? _buildLoadingIndicator() : _buildBody(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    if (_album == null) {
      return const Center(child: Text('Álbum não encontrado.'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Uso de ImageGradientBackground para a imagem do álbum
          ImageGradientBackground(
            backgroundUrl: _album!.image ?? 'https://placekitten.com/300/300',
            foreground: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Nome do álbum e botão TOCAR no mesmo Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _album!.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _album!.tracks.isNotEmpty
                            ? () => _onPlayPressed(context, _album!.tracks)
                            : null,
                        child: const Text('TOCAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Nome do artista e quantidade de músicas
                  Row(
                    children: [
                      Text(
                        widget.artistName,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 8), 
                      Text(
                        '${_album!.tracks.length} músicas',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Lista de faixas do álbum
          ..._album!.tracks.map((track) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    _album!.image ?? 'https://placekitten.com/300/300'),
              ),
              title: Text(
                track.name,
                overflow: TextOverflow.fade, // Usando fade
                softWrap: false, // Impedindo quebra de linha
                maxLines: 1, // Limitando a uma linha
              ),
              subtitle: Text(
                track.artistsNames,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.fade, // Usando fade no subtítulo também
                softWrap: false, // Impedindo quebra de linha
                maxLines: 1, // Limitando a uma linha
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FavoriteButton(track: track),
                  TrackMenu(track: track),
                ],
              ),
              onTap: () => _onPlayPressed(context, _album!.tracks),
            );
          }).toList(),
        ],
      ),
    );
  }
}
