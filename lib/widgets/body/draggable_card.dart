import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:funny_tinder_with_friends/widgets/body/profile_card.dart';

class DraggableCard extends StatefulWidget {
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Offset cardOffset = Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  AnimationController slideOutAnimation;
  Tween<Offset> slideOutTween;

  @override
  void initState() {
    super.initState();
    slideBackAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addListener(() => setState(() {
                cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                    Curves.elasticOut.transform(slideBackAnimation.value));
              }))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                dragStart = null;
                slideBackStart = null;
                dragPosition = null;
              });
            }
          });

    slideOutAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addListener((){
            setState(() {
              cardOffset = slideOutTween.evaluate(slideOutAnimation);
            });
          })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        setState(() {
          dragStart = null;
          slideOutTween = null;
          dragPosition = null;
          cardOffset = Offset(0.0, 0.0);
        });
      }
    });
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    super.dispose();
  }

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
              transform:
                  Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
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

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInNopeRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInLikeRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInSuperLikeRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if(isInNopeRegion || isInLikeRegion){
        slideOutTween = Tween(begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);
      } else if (isInSuperLikeRegion){
        slideOutTween = Tween(begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return Offset(0.0, 0.0);
    }
  }
}
