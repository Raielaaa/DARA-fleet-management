import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteViewPage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  const RouteViewPage({required this.startPoint, required this.endPoint});

  @override
  _RouteViewPageState createState() => _RouteViewPageState();
}

class _RouteViewPageState extends State<RouteViewPage> {
  late GoogleMapController mapController;
  Set<Polyline> routePolyline = {};
  Set<Marker> routeMarkers = {};

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    final String apiKey = 'AIzaSyANm28tCwij2AaUN3eF43g98PVE5IWBKJE';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.startPoint.latitude},${widget.startPoint.longitude}&destination=${widget.endPoint.latitude},${widget.endPoint.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      final polyline = _decodePolyline(points);

      setState(() {
        routePolyline = {
          Polyline(
            polylineId: PolylineId('route'),
            points: polyline,
            color: Colors.blue,
            width: 5,
          ),
        };

        routeMarkers = {
          Marker(
            markerId: MarkerId('startPoint'),
            position: widget.startPoint,
            infoWindow: InfoWindow(title: 'Start Point'),
          ),
          Marker(
            markerId: MarkerId('endPoint'),
            position: widget.endPoint,
            infoWindow: InfoWindow(title: 'End Point'),
          ),
        };
      });
    } else {
      print('Failed to fetch directions: ${response.body}');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            (widget.startPoint.latitude + widget.endPoint.latitude) / 2,
            (widget.startPoint.longitude + widget.endPoint.longitude) / 2,
          ),
          zoom: 10.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: routeMarkers,
        polylines: routePolyline,
      ),
    );
  }
}
