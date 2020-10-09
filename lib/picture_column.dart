import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:goinghome/single_image.dart';

class PictureColumn extends StatefulWidget {
  final Uint8List imageBytes;
  final double height;
  final double width;
  final ScrollController controller;

  const PictureColumn({
    Key key,
    @required this.imageBytes,
    @required this.height,
    @required this.width,
    @required this.controller,
  }) :
        assert(imageBytes != null),
        assert(height != null),
        assert(width != null),
        assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PictureColumnState();
}

class _PictureColumnState extends State<PictureColumn> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: widget.width,
      child: ListView(
          scrollDirection: Axis.vertical,
          controller: widget.controller,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SingleImage(
                key: Key("top"),
                height: widget.height,
                width: widget.width,
                imageBytes: widget.imageBytes
            ),
            SingleImage(
                key: Key("bottom"),
                height: widget.height,
                width: widget.width,
                imageBytes: widget.imageBytes
            ),
          ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}