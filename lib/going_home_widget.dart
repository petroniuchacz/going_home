import 'package:flutter/cupertino.dart';

import 'infinite_background.dart';

class GoingHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoingHomeWidgetState();
}

class _GoingHomeWidgetState extends State<GoingHomeWidget> {
  static const _pxToRad = 200.0;
  double _radX;
  double _radY;

  @override
  void initState() {
    _radX = 0.0;
    _radY = 0.0;
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
      child: GestureDetector(
        onPanUpdate: _onDrag,
        child: InfiniteBackground(
          radsX: _radX,
          radsY: _radY,
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
}