import 'package:flutter/material.dart';

class SelectedPhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int visiblePhotoIndex;

  const SelectedPhotoIndicator({this.photoCount, this.visiblePhotoIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(children: _buildIndicators()),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; i++) {
      indicators.add(
          i == visiblePhotoIndex
              ? _buildActiveIndicator()
              : _buildInactiveIndicator()
      );
    }

    return indicators;
  }

  Widget _buildInactiveIndicator() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.5)),
        ),
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              spreadRadius: 0.0,
              blurRadius: 2.0,
              offset: Offset(0.0, 1.0)
            )
          ]),
        ),
      ),
    );
  }
}
