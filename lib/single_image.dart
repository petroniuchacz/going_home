import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

class SingleImage extends StatefulWidget {
  final Uint8List imageBytes;
  final double height;
  final double width;

  const SingleImage({
    Key key,
    @required this.imageBytes,
    @required this.height,
    @required this.width,
  }) :
      assert(imageBytes != null),
      assert(height != null),
      assert(width != null),
      super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      key: widget.key,
      height: widget.height,
      width: widget.width,
      child: Image(
        image: MemoryImage(widget.imageBytes),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}