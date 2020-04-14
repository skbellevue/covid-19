import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(47.6062, -122.3321), zoom: 2.0);


class EmbeddedMap extends StatefulWidget {
  const EmbeddedMap(this.markers, {this.onTap});
  final List<Marker> markers;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => _EmbeddedMapState();
}

class _EmbeddedMapState extends State<EmbeddedMap> {
  _EmbeddedMapState();

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: _kInitialPosition,
        markers: Set<Marker>.of(widget.markers),
        onTap: (LatLng location) {
          setState(() {
            this.widget.onTap();
          });
        });

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 300.0,
            child: googleMap,
          ),
        ),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }
}
