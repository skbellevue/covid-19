import 'package:flutter/material.dart';

class CovidMarker extends StatelessWidget {
  const CovidMarker({Key key, this.dimension}) : super(key: key);
  final double dimension;

  @override
  Widget build(BuildContext context) {
    double w = 16.0;
    if (dimension > 500 && dimension < 1000) {
      w = 24.0;
    } else if (dimension >= 1000 && dimension < 3000) {
      w = 28.0;
    } else if (dimension >= 3000 && dimension < 8000) {
      w = 32.0;
    } else if (dimension >= 8000 && dimension < 10000) {
      w = 38.0;
    } else if (dimension >= 10000) {
      w = 44.0;
    }
    return Container(
      height: w,
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w / 2),
        color: Colors.redAccent,
      ),
    );
  }
}