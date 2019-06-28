import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:funny_tinder_with_friends/widgets/body/profile_card.dart';

class DraggableCard extends StatefulWidget {
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {

  Offset cardOffset = Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
        showOverlay: true,
        child: Center(),
        overlayBuilder:
            (BuildContext context, Rect anchorBounds, Offset anchor) {
          return CenterAbout(
            position: anchor,
            child: Transform(
              transform: Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                ..rotateZ(_rotation(anchorBounds)),
              origin: _rotationOrigin(anchorBounds),
              child: Container(
                width: anchorBounds.width,
                height: anchorBounds.height,
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: ProfileCard()),
              ),
            ),
          );
        });
  }

  void _onPanStart(DragStartDetails details){
    dragStart = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details){
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details){
    setState(() {
      dragStart = null;
      dragPosition = null;
      cardOffset = Offset(0, 0);
    });
  }

  double _rotation(Rect dragBounds){
    if(dragStart != null){
      return (pi / 8) * (cardOffset.dx / dragBounds.width);
    }else{
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds){
    if(dragStart != null){
      return (pi / 8) * (cardOffset.dx / dragBounds.width);
    }else{
      return Offset(0.0);
    }
  }
}
