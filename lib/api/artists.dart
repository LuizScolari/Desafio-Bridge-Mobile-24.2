import 'dart:convert';

import 'package:beat/api/endpoints.dart';
import 'package:beat/models.dart';
import 'package:http/http.dart' as http;

Future<FullArtist> fetchArtist(String id) async {
  print('fetchArtist $id');
  final response = await http.get(Uri.parse(Endpoints.artist(id)));
  final data = jsonDecode(response.body);
  return FullArtist.fromJson(data as Map<String, dynamic>);
}
