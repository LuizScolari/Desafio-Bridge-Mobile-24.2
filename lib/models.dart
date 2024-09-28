class Track {
  final String id;
  final String name;
  final String? previewUrl;
  final int durationSeconds;

  final Album album;
  final List<Artist> artists;

  String get artistsNames => artists.map((a) => a.name).join(', ');

  Track({
    required this.id,
    required this.name,
    required this.previewUrl,
    required this.durationSeconds,
    required this.album,
    required this.artists,
  });

  factory Track.fromJson(Map<String, dynamic> data) {
    return Track(
      id: data['id'] as String,
      name: data['name'] as String,
      previewUrl: data['previewUrl'] as String?,
      durationSeconds: data['durationSeconds'] as int,
      artists: (data['artists'] as List<dynamic>)
          .map((a) => Artist.fromJson(a as Map<String, dynamic>))
          .toList(),
      album: Album.fromJson(data['album'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType && id == (other as Track).id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return name;
  }
}

class Artist {
  final String id;
  final String name;

  Artist({
    required this.id,
    required this.name,
  });

  factory Artist.fromJson(Map<String, dynamic> data) {
    return Artist(
      id: data['id'] as String,
      name: data['name'] as String,
    );
  }
}

class FullArtist extends Artist {
  final String image;
  final int followers; //Novo atributo
  final List<FullAlbum> albums;
  final List<Track> topTracks;

  FullArtist({
    required String id,
    required String name,
    required this.image,
    required this.followers, //Novo parâmetro no construtor
    required this.albums,
    required this.topTracks,
  }) : super(id: id, name: name);

  factory FullArtist.fromJson(Map<String, dynamic> data) {
    return FullArtist(
      id: data['id'] as String,
      name: data['name'] as String,
      image: data['image'] as String,
      followers: data['followers'] as int, //Mapeia o atributo da API
      albums: (data['albums'] as List)
          .map((d) => FullAlbum.fromJson(d as Map<String, dynamic>))
          .toList(),
      topTracks: (data['top_tracks'] as List)
          .map((d) => Track.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Album {
  final String id;
  final String name;
  final String? image;

  Album({required this.id, required this.name, required this.image});

  factory Album.fromJson(Map<String, dynamic> data) {
    return Album(
      id: data['id'] as String,
      name: data['name'] as String,
      image: data['image'] as String?,
    );
  }
}

class FullAlbum extends Album {
  final List<Track> tracks;

  FullAlbum({
    required String id,
    required String name,
    required String image,
    required this.tracks,
  }) : super(
          id: id,
          name: name,
          image: image,
        );

  factory FullAlbum.fromJson(Map<String, dynamic> data) {
    return FullAlbum(
      id: data['id'] as String,
      name: data['name'] as String,
      image: data['image'] as String,
      tracks: (data['tracks'] as List)
          .map((d) => Track.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
