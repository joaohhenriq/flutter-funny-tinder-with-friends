import 'package:flutter/material.dart';

class Match extends ChangeNotifier{
  Decision decision = Decision.UNDECIDED;

  void like(){
    if(decision == Decision.UNDECIDED){
      decision = Decision.LIKE;
      notifyListeners();
    }
  }

  void nope(){
    if(decision == Decision.UNDECIDED){
      decision = Decision.NOPE;
      notifyListeners();
    }
  }

  void superLike(){
    if(decision == Decision.UNDECIDED){
      decision = Decision.SUPERLIKE;
      notifyListeners();
    }
  }

  void reset(){
    if(decision != Decision.UNDECIDED){
      decision = Decision.UNDECIDED;
      notifyListeners();
    }
  }
}

enum Decision {
  UNDECIDED,
  NOPE,
  LIKE,
  SUPERLIKE
}