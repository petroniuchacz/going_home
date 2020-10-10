import "dart:math" show pi;
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Model extends StatefulWidget {
  final List<Uint8List> model;
  final double radX;
  final double radY;
  final double correctX;
  final double correctY;
  final int nOfParallels;
  final int nOfMeridians;
  final double scale;
  final bool switchRotationAxis;
  final bool switchXAxisDir;
  final bool switchYAxisDir;

  const Model({
    Key key,
    @required this.model,
    @required this.radX,
    @required this.radY,
    this.correctX = 0,
    this.correctY = 0,
    @required this.nOfParallels,
    @required this.nOfMeridians,
    this.scale = 1.0,
    this.switchRotationAxis = false,
    this.switchXAxisDir = false,
    this.switchYAxisDir = false,
  }) :
      assert(model != null),
      assert(radX != null),
      assert(radY != null),
      assert(nOfParallels != null),
      assert(nOfMeridians != null),
      assert(nOfParallels * nOfMeridians == model.length),
      super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState();

}

class _ModelState extends State<Model> {

  List<double> _parallelList;
  List<double> _meridianList;
  double _correctX;
  double _correctY;
  int _numOfParallels;
  List<Uint8List> _model;
  bool _switchRotationAxis;
  bool _switchXAxisDir;
  bool _switchYAxisDir;

  @override
  void initState() {
    _correctX = widget.correctX;
    _correctY = widget.correctY;
    _parallelList = List.generate(
        widget.nOfParallels, (i) => (i+1) * pi / (widget.nOfParallels + 1));
    _meridianList = List.generate(
        widget.nOfMeridians, (i) => i * 2 * pi / widget.nOfMeridians);
    _numOfParallels = widget.nOfParallels;
    _model = widget.model;
    _switchRotationAxis = widget.switchRotationAxis;
    _switchXAxisDir = widget.switchXAxisDir;
    _switchYAxisDir = widget.switchYAxisDir;
    super.initState();
  }

  @override
  void didUpdateWidget(Model oldWidget) {
    if(oldWidget.radY != widget.radY
        || oldWidget.radX != widget.radX
        || oldWidget.scale != widget.scale) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final switchedX = _switchRotationAxis ? widget.radY : widget.radX;
    final switchedY = _switchRotationAxis ? widget.radX : widget.radY;
    final switchedDirX = _switchXAxisDir ? -switchedX : switchedX;
    final switchedDirY = _switchYAxisDir ? -switchedY : switchedY;
    final adjustedX = (switchedDirX + _correctX) % (2*pi);
    final adjustedY = (switchedDirY + _correctY) % (2*pi);
    final clockwiseX = adjustedX > 0 ? adjustedX : 2*pi + adjustedX;
    final clockwiseY = adjustedY > 0 ? adjustedY : 2*pi + adjustedY;
    final parallelDist = _parallelList.map((e) => (e - clockwiseX).abs()).toList();
    final meridianDist = _meridianList.map((e) => (e - clockwiseY).abs()).toList();
    final parallelDistMin = parallelDist.reduce(min);
    final meridianDistMin = meridianDist.reduce(min);
    int parallelNum;
    for(int i = 0; i < parallelDist.length; i++){
      if(parallelDist[i] == parallelDistMin){
        parallelNum = i;
        break;
      }
    }
    int meridianNum;
    for(int i = 0; i < meridianDist.length; i++){
      if(meridianDist[i] == meridianDistMin){
        meridianNum = i;
        break;
      }
    }
    final modelNum = meridianNum * _numOfParallels + parallelNum;
    print(modelNum);
    final modelView = _model[modelNum];
    return Image(
        image: MemoryImage(
          modelView,
          scale: widget.scale,
        )
    );
  }
}