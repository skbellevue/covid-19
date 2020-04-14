import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Countries.dart';

class MapPinDetails extends StatefulWidget {

  final double pinPosition;
  final HealthData healthData;
  final String country;

  MapPinDetails({ this.pinPosition, this.healthData, this.country});

  @override
  State<StatefulWidget> createState() => _MapPinDetailsState();
}

class _MapPinDetailsState extends State<MapPinDetails> {

  @override
  Widget build(BuildContext context) {
    var fmt = NumberFormat.decimalPattern();
    var strCases = fmt.format(widget.healthData.confirmedCases);
    var strDeaths = fmt.format(widget.healthData.deaths);
    var strRecovered = fmt.format(widget.healthData.recovered);
    
    return AnimatedPositioned(
        bottom: 10,
        right: 0,
        left: 0,
        duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(20),
              // height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: <BoxShadow>[
                  BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
                ]
              ),
              child: Container(
                // margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.country, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Confirmed cases: $strCases', style: TextStyle(fontSize: 14, color: Colors.greenAccent)),
                    Text('Deaths: $strDeaths', style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                    Text('Recovered: $strRecovered', style: TextStyle(fontSize: 14, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            ),
          ),
        );
  }

}