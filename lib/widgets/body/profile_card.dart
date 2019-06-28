import 'package:flutter/material.dart';
import 'package:funny_tinder_with_friends/widgets/body/photo_browser.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(color: Color(0x11000000), blurRadius: 4.0, spreadRadius: 2.0)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[_buildBackground(), _buildProfileSysnopsis()],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return PhotoBrowser(
      photoAssetPaths:[
        "assets/joao.jpeg",
        "assets/coro.jpeg",
        "assets/coro2.jpeg",
        "assets/lucas.jpeg",
        "assets/lucas2.jpeg",
        "assets/maurim.jpeg",
        "assets/maurim2.jpeg",
        "assets/robson.jpeg",
        "assets/rogerio.jpeg",
        "assets/sergio.jpeg",
        "assets/tonhao.jpeg"
      ],
      visiblePhotoIndex: 0,
    );
  }

  Widget _buildProfileSysnopsis() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)])),
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('João Henrique',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  Text('Desenvolvedor de Software',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ))
                ],
              ),
            ),
            Icon(
              Icons.info,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
