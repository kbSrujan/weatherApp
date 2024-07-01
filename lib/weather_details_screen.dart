import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherDetails extends StatelessWidget {
  final Weather weather;

  WeatherDetails({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${weather.temperature}°C',
          style: TextStyle(fontSize: 48),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                'http://openweathermap.org/img/wn/${weather.icon}@2x.png'),
            Text(weather.condition),
          ],
        ),
        Text('Humidity: ${weather.humidity}%'),
        Text('Wind Speed: ${weather.windSpeed} m/s'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Refresh'),
        ),
      ],
    );
  }
}
