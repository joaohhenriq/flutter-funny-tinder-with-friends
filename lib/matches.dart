import 'package:flutter/material.dart';

import 'model/profile_model.dart';

class MatchEngine extends ChangeNotifier {
  final List<Match> _matches;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<Match> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  Match get currentMatch => _matches[_currentMatchIndex];
  Match get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch(){
    if(currentMatch.decision !=Decision.UNDECIDED){
      currentMatch.reset();

      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex = _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;

      notifyListeners();
    }
  }
}

class Match extends ChangeNotifier {

  final Profile profile;
  Decision decision = Decision.UNDECIDED;

  Match({
    this.profile
});

  void like() {
    if (decision == Decision.UNDECIDED) {
      decision = Decision.LIKE;
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.UNDECIDED) {
      decision = Decision.NOPE;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.UNDECIDED) {
      decision = Decision.SUPERLIKE;
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.UNDECIDED) {
      decision = Decision.UNDECIDED;
      notifyListeners();
    }
  }
}

enum Decision { UNDECIDED, NOPE, LIKE, SUPERLIKE }
