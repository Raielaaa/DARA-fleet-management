import 'package:dara_app/controller/utils/constants.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class OpenWeather {
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
        // Permissions are denied, request denied.
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, request cannot be made.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current location.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<Weather>?> getWeatherForecastFromAPI() async {
    try {
      //  retrieve longitute and latitude
      Position position = await _determinePosition();

      //  retrieve forecast date
      WeatherFactory wf = WeatherFactory(Constants.OPEN_WEATHER_API_KEY);
      List<Weather> forecast = await wf.fiveDayForecastByLocation(position.latitude, position.longitude);
      debugPrint(forecast.toString());

      return forecast;
    } catch (e) {
      debugPrint("dp - Error: $e");
      return null;
    }
  }
}