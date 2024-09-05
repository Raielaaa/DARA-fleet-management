import 'package:dara_app/services/weather/open_weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class HomeController {
  Future<List<List<String>>> getWeatherForecast() async {
    OpenWeather openWeather = OpenWeather();
    List<List<String>> forecastData = [];

    try {
      // Await the forecast retrieval
      List<Weather>? retrievedForecast = await openWeather.getWeatherForecastFromAPI();

      if (retrievedForecast != null) {
        // Loop through each Weather object in the list
        for (Weather weather in retrievedForecast) {
          String formattedDate;

          if (!weather.date.toString().contains("14:00:00")) {
            continue;
          }
          try {
            // Parse the date and format it
            DateTime weatherDate = DateTime.parse(weather.date.toString());
            formattedDate = DateFormat('E d').format(weatherDate);
          } catch (e) {
            debugPrint("Error formatting date: $e");
            formattedDate = "Unknown Date";  // Fallback in case of error
          }

          String temperature = weather.temperature?.celsius?.toString() ?? "N/A";
          String wind = weather.windSpeed.toString();
          String weatherCode = weather.weatherIcon.toString();

          // Store the data in a list and add it to forecastData
          debugPrint("Hello Controller - $formattedDate");
          forecastData.add(
            [formattedDate, temperature, wind, weatherCode]
          );
        }
      }
    } catch (e) {
      debugPrint("Error while retrieving weather forecast: $e");
    }

    return forecastData;
  }

  String getCurrentDate() {
    //  Get the current date
    DateTime dateTime = DateTime.now();

    //  date format
    DateFormat formatter = DateFormat("MMMM dd, yyyy");

    //  format current date
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }
}
