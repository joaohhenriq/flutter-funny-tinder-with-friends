import 'package:flutter/material.dart';

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
    return Image.asset(
      "assets/joao.jpeg",
      fit: BoxFit.cover,
    );
  }

  Widget _buildProfileSysnopsis() {
    return Text("asfdasdf");
  }
}
