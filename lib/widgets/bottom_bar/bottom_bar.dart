import 'package:flutter/material.dart';
import 'package:funny_tinder_with_friends/widgets/bottom_bar/round_icon_button.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              iconSize: 30,
            ),
            RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
              onPressed: () {},
              iconSize: 30,
            ),
            RoundIconButton.larger(
              icon: Icons.favorite,
              iconColor: Colors.green,
              onPressed: () {},
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
