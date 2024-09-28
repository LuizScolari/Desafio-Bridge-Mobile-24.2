import 'package:beat/business/favorites.dart';
import 'package:beat/models.dart';
import 'package:beat/screens/home/tab_title.dart';
import 'package:beat/widgets/track_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);

    return ListView(
      children: <Widget>[
        const TabTitle(title: 'Músicas favoritas'),
        if (favorites.loading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (favorites.favorites.isEmpty)
          _buildEmptyFavorites()
        else
          _buildFavoritesList(favorites.favorites),
      ],
    );
  }

  Widget _buildEmptyFavorites() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 200),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Image(
              image: AssetImage('assets/images/empty-favs.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Suas músicas favoritas estarão listadas aqui! \nAperte no coração para favoritar uma música.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Track> favorites) {
    // Cria uma cópia da lista e ordena por nome (ordem alfabética)
    List<Track> sortedFavorites = List.from(favorites)
      ..sort((a, b) => a.name.compareTo(b.name)); // Ordena pelo nome da música

    return Column(
      children: sortedFavorites
          .map((track) => TrackItem(track: track, tracks: sortedFavorites))
          .toList(),
    );
  }
}
