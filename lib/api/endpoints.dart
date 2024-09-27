abstract class Endpoints {
  static const _baseUrl = 'https://caio-musicplayer.builtwithdark.com/';
  static const _email = 'luizrpscolari@gmail.com'; // Altere seu e-mail aqui

  static String track(String id) {
    return '$_baseUrl/tracks/$id';
  }

  static String artist(String id) {
    return '$_baseUrl/artists/$id';
  }

  static String album(String id) {
    return '$_baseUrl/albums/$id';
  }

  static String top() {
    return '$_baseUrl/top';
  }

  static String search(String term) {
    return '$_baseUrl/search?q=$term';
  }

  static String favorites() {
    return '$_baseUrl/favorites?email=$_email';
  }

  static String addFavorite(String id) {
    return '$_baseUrl/favorites/add/$id?email=$_email';
  }

  static String removeFavorite(String id) {
    return '$_baseUrl/favorites/remove/$id?email=$_email';
  }

  static String clearFavorites() {
    return '$_baseUrl/favorites/clear/?email=$_email';
  }
}
