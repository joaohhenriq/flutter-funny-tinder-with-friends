import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {

  final Color firstColor, secondColor, thirdColor;

  AppBackground({this.firstColor, this.secondColor, this.thirdColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint){
        final height = constraint.maxHeight;
        final width = constraint.maxWidth;

        return Stack(
          children: <Widget>[
            Container(
              color: Colors.blue[100],
            ),
            Positioned(
              left: -(height/2 - width/2),
              bottom: height * 0.25,
              child: Container(
                // both use height because it's a circle
                height: height,
                width: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: this.firstColor
                ),
              ),
            ),
            Positioned(
              left: width * 0.15,
              top: -width * 0.6,
              child: Container(
                // both use height because it's a circle
                height: width * 1.6,
                width: width * 1.6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: this.secondColor
                ),
              ),
            ),
            Positioned(
              right: -width * 0.2,
              top: -40,
              child: Container(
                // both use height because it's a circle
                height: width * 0.6,
                width: width * 0.6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: this.thirdColor
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
