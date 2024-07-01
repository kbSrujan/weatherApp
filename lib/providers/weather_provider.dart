import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});

class WeatherState {
  final Weather? weather;
  final bool loading;
  final String? error;
  final List<String> searchedCities;

  WeatherState({
    this.weather,
    this.loading = false,
    this.error,
    this.searchedCities = const [],
  });

  WeatherState copyWith({
    Weather? weather,
    bool? loading,
    String? error,
    List<String>? searchedCities,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      searchedCities: searchedCities ?? this.searchedCities,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState());

  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final weather = await _weatherService.fetchWeather(city);
      state = state.copyWith(weather: weather, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> saveLastSearchedCity(String city) async {
    await _weatherService.saveSearchedCity(city);
    loadSearchedCities();
  }

  void saveSearchedCity2(String city) {
    _weatherService.saveSearchedCity(city);
    loadSearchedCities();
  }

  Future<void> loadSearchedCities() async {
    final cities = await _weatherService.getSearchedCities();
    state = state.copyWith(searchedCities: cities);
  }
}
