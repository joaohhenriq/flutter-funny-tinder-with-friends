import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;
  final double iconSize;

  RoundIconButton.extraLarger({this.icon, this.iconColor, this.onPressed, this.iconSize})
      : size = 70.0;

  RoundIconButton.larger({this.icon, this.iconColor, this.onPressed, this.iconSize})
      : size = 60.0;

  RoundIconButton.small({this.icon, this.iconColor, this.onPressed, this.iconSize})
      : size = 50.0;

  RoundIconButton({this.icon, this.iconColor, this.onPressed, this.size, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10.0
          )
        ]
      ),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 0.0,
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize == null ? 25 : iconSize,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
