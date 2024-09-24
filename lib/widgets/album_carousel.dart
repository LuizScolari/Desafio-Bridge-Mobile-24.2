import 'package:beat/models.dart';
import 'package:beat/screens/routes.dart';
import 'package:flutter/material.dart';

class AlbumCarousel extends StatelessWidget {
  final List<Album> albums;
  final Artist artist;

  const AlbumCarousel({
    Key? key,
    required this.albums,
    required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 166),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 16),
          for (final album in albums) _AlbumCarouselItem(album: album, artist: artist),
        ],
      ),
    );
  }
}

class _AlbumCarouselItem extends StatelessWidget {
  final Album album;
  final Artist artist;

  const _AlbumCarouselItem({
    Key? key,
    required this.album,
    required this.artist,
  }) : super(key: key);

  void onPress(BuildContext context) {
    Navigator.push(
      context,
      Routes.album(albumId: album.id, artistName: artist.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(context),
      child: Stack(
        children: <Widget>[
          // background (album cover)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                album.image ?? 'https://placekitten.com/150/150',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // gradient
          Container(
            width: 166,
            height: 166,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 0.7, 1],
                colors: [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // foreground (album name)
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    album.name,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
