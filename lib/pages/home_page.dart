import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:funny_tinder_with_friends/widgets/body/profile_card.dart';
import 'package:funny_tinder_with_friends/widgets/bottom_bar/bottom_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Image.asset("assets/saneagologo.jpg"),
      ),
      body: _buildCardStack(),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildCardStack(){
    return new AnchoredOverlay(
        showOverlay: true,
        child: Center(),
        overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor){
          return CenterAbout(
            position: anchor,
            child: Container(
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: EdgeInsets.all(16.0),
              child: ProfileCard(),
            ),
          );
        }
    );
  }
}
