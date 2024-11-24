import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreenWeather extends StatefulWidget {
  @override
  _MapScreenWeatherState createState() => _MapScreenWeatherState();
}

class _MapScreenWeatherState extends State<MapScreenWeather> {
  late GoogleMapController mapController;
  LatLng selectedLocation = LatLng(14.195691850762733, 121.1643007807619);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location')),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: selectedLocation,
          zoom: 12.0,
        ),
        onTap: (LatLng location) {
          setState(() {
            selectedLocation = location;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('selectedLocation'),
            position: selectedLocation,
          ),
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () async {
            PersistentData _persistentData = PersistentData();

            _persistentData.weatherMapsLongitude = selectedLocation.longitude;
            _persistentData.weatherMapsLatitude = selectedLocation.latitude;

            // Fetch the list of placemarks
            List<Placemark> placemarks = await placemarkFromCoordinates(
                selectedLocation.latitude, selectedLocation.longitude
            );

            // Extract the first placemark (most relevant)
            Placemark place = placemarks[0];

            // Format the detailed location
            String detailedLocation = "${place.locality} ${place.subLocality}";

            // Clean up the result to remove any null or empty fields
            detailedLocation = detailedLocation.replaceAll(", null", "").replaceAll(", ,", "");

            //  for distance calculation
            _persistentData.weatherShortLocation = detailedLocation;

            // Navigate back and pass the selected location
            Navigator.pop(context, detailedLocation);
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}