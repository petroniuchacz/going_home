import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goinghome/picture_column.dart';
import "dart:math" show pi;

class InfiniteBackground extends StatefulWidget {
  final double radsX;
  final double radsY;

  const InfiniteBackground({
    Key key,
    @required this.radsX,
    @required this.radsY,
  }) :
        assert(radsX != null),
        assert(radsY != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteBackgroundState();
}

class _InfiniteBackgroundState extends State<InfiniteBackground> {
  bool _loading;
  Uint8List _imageBytes;
  ScrollController _horizontalScroll;
  ScrollController _verticalScrollLeft;
  ScrollController _verticalScrollRight;
  double _pictureHeight;
  double _pictureWidth;

  @override
  void initState() {
    _horizontalScroll = ScrollController();
    _verticalScrollLeft = ScrollController();
    _verticalScrollRight = ScrollController();
    _loading = true;
    _init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final backgroundToScreenHeight = 4;
    _pictureHeight = backgroundToScreenHeight * height;
    _pictureWidth = _pictureHeight;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(InfiniteBackground oldWidget) {
    if(!_loading) _scroll();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if(!_loading) {
      return Container(
        height: 2*_pictureHeight,
        width: 2* _pictureWidth,
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: _horizontalScroll,
          physics: NeverScrollableScrollPhysics(),
          children: [
            PictureColumn(
              key: Key("left"),
              width: _pictureWidth,
              height: _pictureHeight,
              imageBytes: _imageBytes,
              controller: _verticalScrollLeft,
            ),
            PictureColumn(
              key: Key("right"),
              width: _pictureWidth,
              height: _pictureHeight,
              imageBytes: _imageBytes,
              controller: _verticalScrollRight,
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void _scroll() {
    _horizontalScroll.jumpTo(_horizontalOffset(widget.radsY));
    final verticalOffset = _verticalOffset(widget.radsX);
    if(_verticalScrollLeft.hasClients)
      _verticalScrollLeft.jumpTo(verticalOffset);
    if(_verticalScrollRight.hasClients)
      _verticalScrollRight.jumpTo(verticalOffset);
  }

  double _horizontalOffset(double rad) {
    final maxExtent = _horizontalScroll.position.maxScrollExtent;
    final origin = _pictureWidth;
    final toBorder = _pictureWidth;
    final correctedRad = rad % (2*pi);
    final offset = origin + toBorder * correctedRad / (2*pi);
    return offset > maxExtent - 100 ? offset - toBorder : offset;
  }

  double _verticalOffset(double rad) {
    final maxExtent = _verticalScrollLeft.position?.maxScrollExtent
        ?? _verticalScrollRight.position?.maxScrollExtent;
    final origin = _pictureHeight; //maxExtent / 2;
    final toBorder = _pictureHeight; //maxExtent / 2;
    final correctedRad = rad % (2*pi);
    final offset = origin + toBorder * correctedRad / (2*pi);
    return offset > maxExtent - 100 ? offset - toBorder : offset;
  }

  void _init() async {
    final data = (await rootBundle.load('assets/model_in_the_center.jpg'))
        .buffer
        .asUint8List();
    setState(() {
      _loading = false;
      _imageBytes = data;
    });
  }
}

