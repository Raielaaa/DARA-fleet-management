import 'package:dara_app/controller/utils/constants.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class OpenWeather {
  // Function to get the user's current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request for enabling them.
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied.
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Function to retrieve weather forecast (with optional latitude/longitude parameters)
  Future<List<Weather>?> getWeatherForecastFromAPI(double? longitude, double? latitude) async {
    try {
      // Use provided latitude/longitude, or determine current location if not provided
      if (latitude == null || longitude == null) {
        Position position = await _determinePosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      debugPrint("Longitude: $longitude");
      debugPrint("Latitude: $latitude");
      // Retrieve forecast data using the latitude and longitude
      WeatherFactory wf = WeatherFactory(Constants.OPEN_WEATHER_API_KEY);
      List<Weather> forecast = await wf.fiveDayForecastByLocation(latitude, longitude);

      return forecast;
    } catch (e) {
      debugPrint("dp - Error: $e");
      return null;
    }
  }
}
