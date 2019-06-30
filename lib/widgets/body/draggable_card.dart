import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:funny_tinder_with_friends/model/profile_model.dart';
import 'package:funny_tinder_with_friends/widgets/body/photo_browser.dart';
import 'package:funny_tinder_with_friends/widgets/body/profile_card.dart';
import 'package:funny_tinder_with_friends/matches.dart';

class CardStack extends StatefulWidget {
  final MatchEngine matchEngine;

  const CardStack({this.matchEngine});

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  Match _currentMatch;
  double _nextCardScale = 0.9;

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);

    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch.addListener(_onMatchChange);

    _frontCard = new Key(_currentMatch.profile.name);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }

    widget.matchEngine.removeListener(_onMatchEngineChange);
  }

  void _onMatchEngineChange() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }

      _frontCard = new Key(_currentMatch.profile.name);

      setState(() {

      });
  }

  void _onMatchChange() {
    setState(() {
      //current match may have changed state, re-render
    });
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    Match currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        break;
      case SlideDirection.right:
        currentMatch.like();
        break;
      case SlideDirection.up:
        currentMatch.superLike();
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
        ),
        DraggableCard(
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideOutComplete: _onSlideOutComplete,
        ),
      ],
    );
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.NOPE:
        return SlideDirection.left;
        break;
      case Decision.LIKE:
        return SlideDirection.right;
        break;
      case Decision.SUPERLIKE:
        return SlideDirection.up;
        break;
      default:
        return null;
    }
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        profile: widget.matchEngine.nextMatch.profile,
      ),
    );
  }

  Widget _buildFrontCard() {
    return ProfileCard(
        key: _frontCard, profile: widget.matchEngine.currentMatch.profile);
  }
}

enum SlideDirection { left, right, up }

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;

  const DraggableCard(
      {this.card,
      this.isDraggable = true,
      this.slideTo,
      this.onSlideUpdate,
      this.onSlideOutComplete});

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
  SlideDirection slideOutDirection;
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

                if (null != widget.onSlideUpdate) {
                  widget.onSlideUpdate(cardOffset.distance);
                }
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {
              cardOffset = slideOutTween.evaluate(slideOutAnimation);

              if (null != widget.onSlideUpdate) {
                widget.onSlideUpdate(cardOffset.distance);
              }
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                dragStart = null;
                slideOutTween = null;
                dragPosition = null;

                if (widget.onSlideOutComplete != null) {
                  widget.onSlideOutComplete(slideOutDirection);
                }
              });
            }
          });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0, 0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
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
                key: profileCardKey,
                width: anchorBounds.width,
                height: anchorBounds.height,
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: widget.card),
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

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection = SlideDirection.up;
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

  void _slideLeft() async {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween =
        Tween(begin: Offset(0, 0), end: Offset(-2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideRight() async {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(begin: Offset(0, 0), end: Offset(2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideUp() async {
    final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween =
        Tween(begin: Offset(0, 0), end: Offset(0, -2 * screenHeight));
    slideOutAnimation.forward(from: 0);
  }

  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset(0, 0));
    final dragStartY = cardContext.size.height *
            (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardTopLeft.dy;
    return Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
  }
}

class ProfileCard extends StatefulWidget {

  final Profile profile;

  const ProfileCard({Key key, this.profile}) : super(key: key);

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
      photoAssetPaths: widget.profile.photos,
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
                  Text(widget.profile.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  Text(widget.profile.bio,
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