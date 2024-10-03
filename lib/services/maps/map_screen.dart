import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng selectedLocation = LatLng(14.195691850762733, 121.1643007807619); // Default to San Francisco

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          PersistentData _persistentData = PersistentData();

          _persistentData.mapsLongitude = selectedLocation.longitude.toString();
          _persistentData.mapsLatitude = selectedLocation.latitude.toString();

          // Fetch the list of placemarks
          List<Placemark> placemarks = await placemarkFromCoordinates(
              selectedLocation.latitude, selectedLocation.longitude
          );

          // Extract the first placemark (most relevant)
          Placemark place = placemarks[0];

          // Format the detailed location
          String detailedLocation = "${place.subThoroughfare}, "
              "${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}, "
              "${place.administrativeArea}, ${place.postalCode}, ${place.country}";

          // Clean up the result to remove any null or empty fields
          detailedLocation = detailedLocation.replaceAll(", null", "").replaceAll(", ,", "");

          // Debug print the detailed location
          debugPrint("Detailed Location: $detailedLocation");

          _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude = detailedLocation;
          debugPrint("Brief selected location - ${_persistentData.bookingDetailsMapsLocationFromLongitudeLatitude}");

          // Navigate back and pass the selected location
          Navigator.pop(context, detailedLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}