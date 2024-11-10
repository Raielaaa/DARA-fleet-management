import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreenGarage extends StatefulWidget {
  @override
  _MapScreenGarageState createState() => _MapScreenGarageState();
}

class _MapScreenGarageState extends State<MapScreenGarage> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          PersistentData _persistentData = PersistentData();

          // Update PersistentData with selected location
          _persistentData.mapsGarageLongitude = selectedLocation.longitude.toString();
          _persistentData.mapsGarageLatitude = selectedLocation.latitude.toString();

          debugPrint("Longitude: ${_persistentData.mapsGarageLongitude}");
          debugPrint("Latitude: ${_persistentData.mapsGarageLatitude}");

          // Fetch detailed location info using geocoding
          List<Placemark> placemarks = await placemarkFromCoordinates(
              selectedLocation.latitude, selectedLocation.longitude
          );
          Placemark place = placemarks[0];

          // Format detailed location
          String detailedLocation = "${place.subThoroughfare}, "
              "${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}, "
              "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
          detailedLocation = detailedLocation.replaceAll(", null", "").replaceAll(", ,", "");

          debugPrint("Detailed Location: $detailedLocation");

          // Save selected location to Firestore
          await updateGarageLocationInFirestore(selectedLocation.latitude, selectedLocation.longitude);

          // Navigate back and pass the selected location
          Navigator.pop(context, detailedLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> updateGarageLocationInFirestore(double latitude, double longitude) async {
    try {
      await FirebaseFirestore.instance
          .collection("dara-garage-location")
          .doc("garage_location")
          .update({
        'garage_location_latitude': latitude.toString(),
        'garage_location_longitude': longitude.toString(),
      });
      debugPrint("Garage location updated successfully in Firestore.");
    } catch (e) {
      debugPrint("Error updating garage location: $e");
    }
  }
}
