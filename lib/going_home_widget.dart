import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'infinite_background.dart';

class GoingHomeWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GoingHomeWidgetState();
}

class _GoingHomeWidgetState extends State<GoingHomeWidget> {

  static const _pxToRad = 200.0;
  bool _loading;
  Uint8List _background;
  Uint8List _flippedBackground;
  double _radX;
  double _radY;

  @override
  void initState() {
    _loading = true;
    _radX = 0.0;
    _radY = 0.0;
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Container(
      width: width,
      height: height,
      child: _loading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
        onPanUpdate: _onDrag,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            InfiniteBackground(
              imageBytes: _background,
              flippedImageBytes: _flippedBackground,
              radsX: _radX,
              radsY: _radY,
            ),
          ],
        ),
      ),
    );
  }

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      _radX -= details.delta.dy / _pxToRad;
      _radY -= details.delta.dx / _pxToRad;
    });
  }

  void _init() async {
    final backgroundBytes =
        (await rootBundle.load('assets/model_in_the_center.jpg'))
        .buffer
        .asUint8List();

    final flippedBackgroundBytes =
        (await rootBundle.load('assets/model_in_the_center - Copy.jpg'))
        .buffer
        .asUint8List();

    setState(() {
      _loading = false;
      _background = backgroundBytes;
      _flippedBackground = flippedBackgroundBytes;
    });
  }
}