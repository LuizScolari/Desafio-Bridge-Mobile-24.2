import 'package:beat/api/tracks.dart';
import 'package:beat/models.dart';
import 'package:flutter/widgets.dart';

const _debug = false;

class Favorites extends ChangeNotifier {
  List<Track> _favorites = [];
  final List<Track> _added = [];
  final List<Track> _removed = [];
  bool _loading = false;

  bool get loading => _loading;

  List<Track> get favorites {
    return _favorites.where((track) => !_removed.contains(track)).toList();
  }

  Favorites() {
    _load();
  }

  Future<void> add(Track track) async {
    _added.add(track);
    notifyListeners();
    _load(await addFavorite(track.id));
    _log();
  }

  Future<void> remove(Track track) async {
    _removed.add(track);
    notifyListeners();
    _load(await removeFavorite(track.id));
    _log();
  }

  Future<void> clear() async {
    _removed.addAll(_favorites);
    notifyListeners();
    _load(await clearFavorites());
  }

  bool contains(Track track) {
    return (_favorites.contains(track) || _added.contains(track)) && !_removed.contains(track);
  }

  bool editable(Track track) {
    return !_added.contains(track) && !_removed.contains(track);
  }

  bool clearable() {
    return _added.isEmpty && _removed.isEmpty;
  }

  Future<void> _load([List<Track>? tracks]) async {
    if (tracks == null) {
      _setLoading(true);
      _favorites = await fetchFavorites();
      _setLoading(false);
    } else {
      _favorites = tracks;
    }

    _syncChanges();
    notifyListeners();
    _log();
  }

  void _setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }

  void _syncChanges() {
    _added.removeWhere((track) => _favorites.contains(track));
    _removed.removeWhere((track) => !_favorites.contains(track));
  }

  void _log() {
    if (_debug) {
      print('$runtimeType(${{
        'favorites': _favorites,
        'added': _added,
        'removed': _removed,
      }})');
    }
  }
}
