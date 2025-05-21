import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mininal_weather_app/model/weather.model.dart';
import 'package:mininal_weather_app/services/weather.service.dart';
import 'package:mininal_weather_app/utils/deleted-city.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServices = WeatherService('35cbddc21197bd51e33e4050cb887542');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherServices.getCurrentCity();
    print('Detected city: ${cityName}');
    try {
      final weather = await _weatherServices.getWeather(removeDiacritics(cityName));
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/Sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke': 
      case 'haze': 
      case 'dust': 
      case 'fog': 
        return 'assets/Cloud.json';
      case 'rain': 
      case 'drizzle':
      case 'shower rain':
        return 'assets/Rain.json';
      case 'thunderstorm': 
        return 'assets/Thunder.json';
      case 'clear':
        return 'assets/Sunny.json';
      default: 
        return 'assets/Sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _weather == null
                ? const CircularProgressIndicator()
                : Column(
                  children: [
                    Text(_weather!.cityName),
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                    Text('${_weather!.temperature.round()}°C'),
                    Text(_weather?.mainCondition ?? "")
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
