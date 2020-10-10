import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goinghome/picture_column.dart';
import "dart:math" show pi;

class InfiniteBackground extends StatefulWidget {
  final double radsX;
  final double radsY;
  final Uint8List imageBytes;
  final Uint8List flippedImageBytes;

  const InfiniteBackground({
    Key key,
    @required this.radsX,
    @required this.radsY,
    @required this.imageBytes,
    @required this.flippedImageBytes,
  }) :
        assert(radsX != null),
        assert(radsY != null),
        assert(imageBytes != null),
        assert(flippedImageBytes != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteBackgroundState();
}

class _InfiniteBackgroundState extends State<InfiniteBackground> {
  Uint8List _imageBytes;
  Uint8List _flippedImageBytes;
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
    _imageBytes = widget.imageBytes;
    _flippedImageBytes = widget.flippedImageBytes;
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
    _scroll();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
            imageBytes: _flippedImageBytes,
            controller: _verticalScrollRight,
          ),
        ],
      ),
    );
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
}

