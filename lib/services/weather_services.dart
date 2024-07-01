import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String apiKey = 'd444b1046184227c8692759154ef7e6f';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final url = '$baseUrl?q=$city&units=metric&appid=$apiKey';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decodedJson = json.decode(response.body);
        print('Decoded JSON: $decodedJson');
        return Weather.fromJson(decodedJson);
      } catch (e) {
        print('Error parsing JSON: $e');
        throw Exception('Failed to parse weather data: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else {
      throw Exception('Failed to load weather data: ${response.body}');
    }
  }

  Future<List<String>> getSearchedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('searchedCities') ?? [];
  }

  Future<void> saveSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final searchedCities = prefs.getStringList('searchedCities') ?? [];
    if (!searchedCities.contains(city)) {
      searchedCities.add(city);
      await prefs.setStringList('searchedCities', searchedCities);
    }
  }
}
