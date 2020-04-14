import 'dart:convert';

import 'package:covid_tracker/MarkerGenerator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Countries.dart';
import 'CovidMarker.dart';
import 'EmbeddedMap.dart';
import 'MapPinDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'COVID-19 Stats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int confirmedCases = 0;
  int deaths = 0;
  int recovered = 0;

  Map<String, HealthData> _countriesData = Map();
  List<Marker> markers = List();

  HealthData currentlySelectedPinData;
  String currentlySelectedCountry;

  @override
  void initState() {
    super.initState();
    _fetchData(null);
  }

  void _refreshData() async {
    _fetchData(null);
  }

  // This method fetches COVID data for a country, or globaly if country is null
  void _fetchData(String country) async {
    var url = "https://covid19-api.weedmark.systems/api/v1/stats";
    if (country != null) {
      url = "$url?country=$country";
    }

    var resp = await http.get(url);
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var data = body["data"];
      List<dynamic> stats = data["covid19Stats"];

      confirmedCases = deaths = recovered = 0;

      if (country == null) {
        markers.clear();
        _countriesData.clear();

        // consolidate data
        stats.forEach((entry) {
          var country = entry["country"];
          var countryData = _countriesData[country];
          if (countryData == null) {
            countryData = HealthData();
            _countriesData[country] = countryData;
          }

          countryData.confirmedCases += entry["confirmed"];
          countryData.deaths += entry["deaths"];
          countryData.recovered += entry["recovered"];

          confirmedCases += entry["confirmed"];
          deaths += entry["deaths"];
          recovered += entry["recovered"];
        });

        // We create widgets for the map markers
        var listOfCountries = _countriesData.keys.toList();
        var widgets = listOfCountries.map((country) {
          var data = _countriesData[country];
          return CovidMarker(
            dimension: data.confirmedCases + 0.0,
          );
        }).toList();

        var generator = MarkerGenerator(widgets, (bytes) {
          for (var i = 0; i < widgets.length; i++) {
            var aCountry = listOfCountries.elementAt(i);
            var desc = bytes.elementAt(i);

            markers.add(Marker(
                markerId: MarkerId(aCountry),
                position: Countries.coordinates(aCountry),
                icon: BitmapDescriptor.fromBytes(desc),
                onTap: () {
                  setState(() {
                    currentlySelectedPinData = _countriesData[aCountry];
                    currentlySelectedCountry = aCountry;
                  });
                }));
          }

          setState(() {});
        });
        generator.generate(context);
      } else {
        stats.forEach((entry) {
          confirmedCases += entry["confirmed"];
          deaths += entry["deaths"];
          recovered += entry["recovered"];
        });
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var fmt = NumberFormat.decimalPattern();
    var strCases = fmt.format(this.confirmedCases);
    var strDeaths = fmt.format(this.deaths);
    var strRecovered = fmt.format(this.recovered);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.language),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildPortraitView(strCases, strDeaths, strRecovered);
        } else {
          return _buildMap();
        }
      },) ,


      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        tooltip: 'Refresh',
        
        child: Icon(Icons.refresh),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop
      , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildPortraitView(String strCases, String strDeaths, String strRecovered) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      width: double.infinity,
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "CONFIRMED CASES",
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Text(
            strCases,
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.greenAccent,
          ),
          Text("DEATHS",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(strDeaths,
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 36,
                  fontWeight: FontWeight.bold)),
          Divider(
            color: Colors.greenAccent,
          ),
          Text("RECOVERED",
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(strRecovered,
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 36,
                  fontWeight: FontWeight.bold)),
          Divider(
            color: Colors.greenAccent,
          ),
          _buildMap(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
          children: <Widget>[
            EmbeddedMap(
              markers,
              onTap: () {
                setState(() {
                  currentlySelectedPinData = null;
                  currentlySelectedCountry = null;
                });
              },
            ),
            if (currentlySelectedPinData != null) MapPinDetails(
              healthData: currentlySelectedPinData,
              country: currentlySelectedCountry,
              pinPosition: 0,
            )
          ],
        );
  }
}
