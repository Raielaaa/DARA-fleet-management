import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/controller/utils/constants.dart";
import "package:google_maps_webservice/directions.dart";
import "package:flutter/material.dart";

class DistanceCalculator {
  final String apiKey = Constants.DIRECTION_API_KEY;
  late GoogleMapsDirections _directions;

  DistanceCalculator() {
    _directions = GoogleMapsDirections(apiKey: apiKey);
  }

  Future<void> calculateDistance(double startLat, double startLng, double endLat, double endLng) async {
    try {
      debugPrint("start-lat: $startLat");
      debugPrint("start-long: $startLng");
      //  making a request to Google Directions API
      DirectionsResponse response = await _directions.directionsWithLocation(
        Location(lat: startLat, lng: startLng),
        Location(lat: endLat, lng: endLng),
        travelMode: TravelMode.driving,
      );

      if (response.isOkay) {
        //  extract the distance in meters from the response
        final distance = response.routes[0].legs[0].distance;
        final duration = response.routes[0].legs[0].duration;
        PersistentData _persistentData = PersistentData();
        _persistentData.drivingDistance = distance.text;
        _persistentData.drivingTimeDuration = duration.text;
      } else {
        debugPrint("Error fetching directions: ${response.errorMessage}");
      }
    } catch (e) {
      debugPrint("Direction API error: $e");
    }
  }

  String getDrivingDistance() {
    return PersistentData().drivingDistance;
  }

  String getDrivingTimeDuration() {
    return PersistentData().drivingTimeDuration;
  }
}