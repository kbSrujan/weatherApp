import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/weather_details_screen.dart';

import '../providers/weather_provider.dart';

class HomeScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final notifier = weatherProvider.notifier;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final city = _controller.text;
                    if (city.isNotEmpty) {
                      try {
                        final weather = await ref
                            .read(weatherProvider.notifier)
                            .saveLastSearchedCity(city);
                      } catch (e) {
                        print('Error: $e');
                      }
                    }
                  },
                ),
              ),
              onTap: () {
                // ref.read(weatherProvider.notifier).loadSearchedCities();
              },
            ),
            if (weatherState.searchedCities.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: weatherState.searchedCities.length,
                  itemBuilder: (context, index) {
                    final city = weatherState.searchedCities[index];
                    return Card(
                      child: ListTile(
                        title: Text(city),
                        onTap: () {
                          _controller.text = city;
                          ref.read(weatherProvider.notifier).fetchWeather(city);
                        },
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(weatherProvider.notifier)
                    .saveLastSearchedCity(_controller.text);
                ref
                    .read(weatherProvider.notifier)
                    .fetchWeather(_controller.text);
              },
              child: Text('Get Weather'),
            ),
            if (weatherState.loading) CircularProgressIndicator(),
            if (weatherState.error != null)
              Text(
                weatherState.error!,
                style: TextStyle(color: Colors.red),
              ),
            if (weatherState.weather != null)
              WeatherDetails(weather: weatherState.weather!),
          ],
        ),
      ),
    );
  }
}
