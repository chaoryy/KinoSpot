import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kinospot/data/exceptions/network_exception.dart';
import 'package:kinospot/data/exceptions/server_exception.dart';
import 'package:kinospot/data/models/movie.dart';
import 'package:kinospot/data/models/session.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:9889';
  static const Duration _timeout = Duration(seconds: 10);
  Future<List<Movie>> getMovies() async {
    var url = Uri.parse('$baseUrl/movies');
    final List<dynamic> response = await _getResponse(url);
    return response.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Session>> getSessionFor(int movieId) async {
    var url = Uri.parse('$baseUrl/movies/$movieId/sessions');
    final List<dynamic> response = await _getResponse(url);
    return response.map((json) => Session.fromJson(json)).toList();
  }

  Future<List<dynamic>> _getResponse(Uri url) async {
    try {
      final response = await http.get(url).timeout(_timeout);
      if(response.statusCode == 200) {
        return jsonDecode(
          utf8.decode(response.bodyBytes),
        );
      } else {
        throw ServerException(
            statusCode: response.statusCode,
            message: response.body,
        );
      }

    } on TimeoutException {
      throw NetworkException(message: 'Server timeout exceeded');
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw NetworkException(message: 'Unknown Network Error: $e');
    }
  }
}
