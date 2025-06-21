import 'package:flutter/material.dart';
import 'package:proval/models/match.dart';
import 'package:proval/providers/api.dart';

class MatchProvider extends ChangeNotifier {
  List<Match>? _matches;
  bool _loading = false;

  List<Match>? get matches => _matches;
  bool get loading => _loading;

  Future<void> fetchMatches({String query = "results"}) async {
    _loading = true;
    notifyListeners();
    final api = API();
    _matches = await api.getMatches(query, 1, 3);
    _loading = false;
    notifyListeners();
  }
}
