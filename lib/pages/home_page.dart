import 'package:flutter/material.dart';
import 'package:funny_tinder_with_friends/model/profile_model.dart';
import 'package:funny_tinder_with_friends/widgets/body/draggable_card.dart';
import 'package:funny_tinder_with_friends/widgets/bottom_bar/round_icon_button.dart';

import '../app_background.dart';
import '../matches.dart';

final MatchEngine matchEngine = new MatchEngine(
    matches: demoProfiles.map((Profile profile){
      return new Match(profile: profile);
    }).toList()
);

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AppBackground(
          firstColor: Colors.blue.withOpacity(0.2),
          secondColor: Colors.white.withOpacity(0.1),
          thirdColor: Colors.white.withOpacity(0.2),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Text("Saneago",style: TextStyle(
              fontFamily: "Barriecito",
              fontSize: 44,
              color: Colors.blue[800]
            ),),
          ),
          body: CardStack(matchEngine: matchEngine,),
          bottomNavigationBar: _buildBottomBar(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(){
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RoundIconButton.small(
              icon: Icons.refresh,
              iconColor: Colors.blue[100],
              iconSize: 20,
            ),
            RoundIconButton.larger(
              icon: Icons.clear,
              iconColor: Colors.red,
              onPressed: () {matchEngine.currentMatch.nope();},
              iconSize: 30,
            ),
            RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
              onPressed: () {matchEngine.currentMatch.superLike();},
              iconSize: 30,
            ),
            RoundIconButton.larger(
              icon: Icons.favorite,
              iconColor: Colors.green,
              onPressed: () {matchEngine.currentMatch.like();},
              iconSize: 30,
            ),
            RoundIconButton.small(
              icon: Icons.lock,
              iconColor: Colors.blue[100],
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
