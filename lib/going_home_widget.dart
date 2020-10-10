import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goinghome/model.dart';

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
  List<Uint8List> _model;
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
            Model(
              model: _model,
              radX: _radX,
              radY: _radY,
              correctX: 0,
              nOfParallels: 38,
              nOfMeridians: 80,
              switchXAxisDir: true,
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

    final manifestJson = await DefaultAssetBundle.of(context)
        .loadString('AssetManifest.json');
    final images = jsonDecode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/rw2'));
    final sortedImgs = List.from(images)..sort();
    final model = List<Uint8List>();
    for(final img in sortedImgs) {
      model.add((await rootBundle.load(img)).buffer.asUint8List());
      print(img);
    }

    setState(() {
      _model = model;
      _loading = false;
      _background = backgroundBytes;
      _flippedBackground = flippedBackgroundBytes;
    });
  }
}