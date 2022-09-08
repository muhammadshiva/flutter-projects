import 'dart:convert';
import 'dart:io';
import 'package:flutter_api/model/movie.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiKey = 'ce180d8884e9edd3c79449aa9b8655c5';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=';

  Future<List> getPopularMovies() async {
    final String uri = baseUrl + apiKey;

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      print("Success");
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
      // String response = result.body;
      // return response;
    } else {
      print("Failed to load data");
      return null;
    }
  }
}
