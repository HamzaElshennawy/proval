import 'dart:convert';
import 'package:proval/models/match.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API extends ChangeNotifier {
  // Base URL for the API
  final String baseUrl = "https://vlrggapi.vercel.app/";

  // Methods to fetch data from the API

  //1 Get the matches https://vlrggapi.vercel.app/match?q=results&num_pages=1&max_retries=3&request_delay=1&timeout=30
  Future<List<Match>?> getMatches(
    String query,
    int? num_pages,
    int? max_retries,
  ) async {
    num_pages ??= 1;
    max_retries ??= 3;
    final String url =
        "${baseUrl}match?q=$query&num_pages=$num_pages&max_retries=$max_retries";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded.map((match) => Match.fromJson(match)).toList();
        } else if (decoded is Map &&
            decoded['data'] is Map &&
            decoded['data']['segments'] is List) {
          // Handle the actual API response structure
          return (decoded['data']['segments'] as List)
              .map((match) => Match.fromJson(match))
              .toList();
        } else if (decoded is Map && decoded['data'] is List) {
          // Fallback for previous structure
          return (decoded['data'] as List)
              .map((match) => Match.fromJson(match))
              .toList();
        } else {
          print("Unexpected response format: $decoded");
        }
      }
    } catch (e) {
      print("Error fetching matches: $e");
    }
    return null;
  }
}
