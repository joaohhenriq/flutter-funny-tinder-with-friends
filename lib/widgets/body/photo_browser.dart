import 'package:flutter/material.dart';
import 'package:funny_tinder_with_friends/widgets/body/selected_photo_indicator.dart';

class PhotoBrowser extends StatefulWidget {

  final List<String> photoAssetPaths;
  final int visiblePhotoIndex;

  const PhotoBrowser({this.photoAssetPaths, this.visiblePhotoIndex});

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {

  int visiblePhotoIndex;


  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }


  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex){
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(widget.photoAssetPaths[visiblePhotoIndex], fit: BoxFit.cover,),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SelectedPhotoIndicator(
            photoCount: widget.photoAssetPaths.length,
            visiblePhotoIndex: visiblePhotoIndex
          )
        ),

        _buildPhotoControls()

      ],
    );
  }

  // quando clica do lado esquerdo, volta a foto
  // quando clica do lado direito, vai para frente
  // aqui controla isso, coloco um stack por cima, com dois gestures detectors
  Widget _buildPhotoControls(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: _prevImage,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: _nextImage,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        )
      ],
    );
  }

  void _prevImage(){
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;
    });
  }

  void _nextImage(){
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;
    });
  }
}