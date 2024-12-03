import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreenChangeLoc extends StatefulWidget {
  @override
  _MapScreenChangeLocState createState() => _MapScreenChangeLocState();
}

class _MapScreenChangeLocState extends State<MapScreenChangeLoc> {
  late GoogleMapController mapController;
  LatLng selectedLocation = LatLng(PersistentData().latitudeForChangeLoc, PersistentData().longitudeForChangeLoc);
  TextEditingController searchController = TextEditingController();
  List<dynamic> placeSuggestions = [];
  final String apiKey = 'AIzaSyANm28tCwij2AaUN3eF43g98PVE5IWBKJE';

  // Check if location is within Luzon bounds
  bool isWithinLuzonBounds(LatLng location) {
    return location.latitude >= 12.8 &&
        location.latitude <= 20.7 &&
        location.longitude >= 118.0 &&
        location.longitude <= 126.0;
  }

  // Check if the location is on land and part of Luzon
  Future<bool> isLandArea(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude, location.longitude);
    Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();
    List<String> luzonAreas = [
      'ilocos region',
      'cordillera administrative region',
      'cagayan valley',
      'central luzon',
      'calabarzon',
      'mimaropa',
      'bicol region',
      'national capital region',
      'zambales',
      'quezon',
      "ncr",
      "bicol",
      "metro manila"
    ];
    return place.administrativeArea != null &&
        luzonAreas.contains(place.administrativeArea!.toLowerCase());
  }

  // Luzon polygon overlay
  Set<Polygon> luzonPolygon = {
    Polygon(
      polygonId: PolygonId('luzonBoundary'),
      points: [
        LatLng(18.7, 119.68), // top-left
        LatLng(18.7, 124.2), // top-right
        LatLng(12.4, 124.2), // bottom-right
        LatLng(14.0, 119.78), // bottom-left
      ],
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.2),
    ),
  };

  // Search Places using Google Places API
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        placeSuggestions.clear();
      });
      return;
    }

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&components=country:ph';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        placeSuggestions = jsonDecode(response.body)['predictions'];
      });
    } else {
      debugPrint('Error fetching place suggestions: ${response.reasonPhrase}');
    }
  }

  // Get LatLng from Place ID
  Future<LatLng> getLatLngFromPlace(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['result'];
      final location = result['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Error fetching place details: ${response.reasonPhrase}');
    }
  }

  // FAB functionality to confirm selection
  void confirmSelection() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Location Confirmed: ${selectedLocation.latitude}, ${selectedLocation.longitude}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select New End Location'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchPlaces(searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: searchPlaces,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 12.0,
            ),
            polygons: luzonPolygon,
            onTap: (LatLng location) async {
              if (isWithinLuzonBounds(location)) {
                bool isLand = await isLandArea(location);
                if (isLand) {
                  setState(() {
                    selectedLocation = location;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Please select a valid land area within Luzon.')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select a location within Luzon boundaries.')));
              }
            },
            markers: {
              Marker(
                markerId: MarkerId('selectedLocation'),
                position: selectedLocation,
              ),
            },
          ),
          if (placeSuggestions.isNotEmpty)
            Positioned(
              top: 100,
              left: 8,
              right: 8,
              child: Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: placeSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = placeSuggestions[index]['description'];
                    final placeId = placeSuggestions[index]['place_id'];

                    return ListTile(
                      title: Text(suggestion),
                      onTap: () async {
                        LatLng location = await getLatLngFromPlace(placeId);
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(location, 14),
                        );

                        if (isWithinLuzonBounds(location) &&
                            await isLandArea(location)) {
                          setState(() {
                            selectedLocation = location;
                            placeSuggestions.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Selected place is not within Luzon boundaries or a valid land area.')));
                        }
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () async {
            // Reverse geocode the selected location
            List<Placemark> placemarks = await placemarkFromCoordinates(
                selectedLocation.latitude, selectedLocation.longitude);
            Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

            // Format the detailed location
            String detailedLocation = "${place.street}, ${place.subThoroughfare}, "
                "${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, "
                "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
            detailedLocation = detailedLocation.replaceAll(", null", "").replaceAll(", ,", "");

            Map<String, String> selectedLocationInformation = {
              "name" : detailedLocation,
              "longitude" : selectedLocation.longitude.toString(),
              "latitude" : selectedLocation.latitude.toString()
            };

            // Navigate back with the selected location
            Navigator.pop(context, selectedLocationInformation);
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}
