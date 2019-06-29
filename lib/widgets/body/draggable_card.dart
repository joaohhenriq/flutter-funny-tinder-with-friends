import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:funny_tinder_with_friends/widgets/body/profile_card.dart';
import 'package:funny_tinder_with_friends/matches.dart';

class DraggableCard extends StatefulWidget {

  final Match match;

  DraggableCard({this.match});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = new GlobalKey(debugLabel: 'profile_card_key');
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

          widget.match.reset();
        });
      }
    });

    widget.match.addListener(_onMatchChange);
    decision = widget.match.decision;
  }


  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.match != oldWidget.match){
      oldWidget.match.removeListener(_onMatchChange);
      widget.match.addListener(_onMatchChange);
    }
  }

  @override
  void dispose() {
    widget.match.removeListener(_onMatchChange);
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
                key: profileCardKey,
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

  void _onMatchChange(){
    if(widget.match.decision != decision){
      switch(widget.match.decision){
        case Decision.NOPE:
          _slideLeft();
          break;
        case Decision.LIKE:
          _slideRight();
          break;
        case Decision.SUPERLIKE:
          _slideUp();
          break;
        default:
          break;
      }
    }

    decision = widget.match.decision;
  }

  void _slideLeft(){
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(begin: Offset(0, 0), end: Offset(-2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideRight(){
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(begin: Offset(0, 0), end: Offset(2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideUp(){
    final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(begin: Offset(0, 0), end: Offset(0, -2 * screenHeight));
    slideOutAnimation.forward(from: 0);
  }

  Offset _chooseRandomDragStart(){
    final cardContext= profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, 0));
    final dragStartY = cardContext.size.height * (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) + cardTopLeft.dy;
    return Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
  }
}
