import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      return Future.error('Location permission not granted');
    }
  }
}


class WeatherCard extends StatelessWidget {
  final String city;
  final String temperature;
  final String humidity;
  final String windDirection;
  final String windSpeed;
  final IconData weatherIcon;

  WeatherCard({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.windDirection,
    required this.windSpeed,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            city,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BoxedIcon(weatherIcon, size: 48.0),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Temperature: $temperature°C',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Humidity: $humidity%',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Wind: $windDirection, $windSpeed km/h',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String city = 'Cargando...';
  String temperature = 'Cargando...';
  String humidity = 'Cargando...';
  String windDirection = 'Cargando...';
  String windSpeed = 'Cargando...';
  IconData weatherIcon = WeatherIcons.day_sunny;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  String getWindDirection(double degree) {
    if (degree > 337.5) return 'North';
    if (degree > 292.5) return 'Northwest';
    if (degree > 247.5) return 'West';
    if (degree > 202.5) return 'Southwest';
    if (degree > 157.5) return 'South';
    if (degree > 122.5) return 'Southeast';
    if (degree > 67.5) return 'East';
    if (degree > 22.5) return 'Northeast';
    return 'East';
  }

  void getWeather() async {
    requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${dotenv.env['WEATHER_API_KEY']}&units=metric'));
    var weatherData = jsonDecode(response.body);
    setState(() {
      city = weatherData['name'];
      temperature = weatherData['main']['temp'].toString();
      humidity = weatherData['main']['humidity'].toString();
      windDirection = getWindDirection(double.parse(weatherData['wind']['deg'].toString()));
      windSpeed = (double.parse(weatherData['wind']['speed'].toString()) * 3.6).toStringAsFixed(2);

      switch (weatherData['weather'][0]['main']) {
        case 'Clear':
          weatherIcon = WeatherIcons.day_sunny;
          break;
        case 'Clouds':
          weatherIcon = WeatherIcons.cloudy;
          break;
        case 'Rain':
          weatherIcon = WeatherIcons.rain;
          break;
        case 'Drizzle':
          weatherIcon = WeatherIcons.sprinkle;
          break;
        case 'Thunderstorm':
          weatherIcon = WeatherIcons.thunderstorm;
          break;
        case 'Snow':
          weatherIcon = WeatherIcons.snow;
          break;
        case 'Mist':
          weatherIcon = WeatherIcons.fog;
          break;
        case 'Smoke':
          weatherIcon = WeatherIcons.smoke;
          break;
        case 'Haze':
          weatherIcon = WeatherIcons.day_haze;
          break;
        case 'Dust':
          weatherIcon = WeatherIcons.dust;
          break;
        case 'Fog':
          weatherIcon = WeatherIcons.fog;
          break;
        case 'Sand':
          weatherIcon = WeatherIcons.sandstorm;
          break;
        case 'Ash':
          weatherIcon = WeatherIcons.volcano;
          break;
        case 'Squall':
          weatherIcon = WeatherIcons.strong_wind;
          break;
        case 'Tornado':
          weatherIcon = WeatherIcons.tornado;
          break;
        default:
          print('Unrecognized weather condition: ${weatherData['weather'][0]['main']}');
          weatherIcon = WeatherIcons.na;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del clima'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getWeather,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          WeatherCard(
            city: city,
            temperature: temperature,
            humidity: humidity,
            windDirection: windDirection,
            windSpeed: windSpeed,
            weatherIcon: weatherIcon,
          ),
        ],
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String city = 'Cargando...';
  String temperature = 'Cargando...';
  String humidity = 'Cargando...';
  String windDirection = 'Cargando...';
  String windSpeed = 'Cargando...';
  IconData weatherIcon = WeatherIcons.day_sunny;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  String getWindDirection(double degree) {
    if (degree > 337.5) return 'North';
    if (degree > 292.5) return 'Northwest';
    if (degree > 247.5) return 'West';
    if (degree > 202.5) return 'Southwest';
    if (degree > 157.5) return 'South';
    if (degree > 122.5) return 'Southeast';
    if (degree > 67.5) return 'East';
    if (degree > 22.5) return 'Northeast';
    return 'East';
  }

  void getWeather() async {
    requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${dotenv.env['WEATHER_API_KEY']}&units=metric'));
    var weatherData = jsonDecode(response.body);
    setState(() {
      city = weatherData['name'];
      temperature = weatherData['main']['temp'].toString();
      humidity = weatherData['main']['humidity'].toString();
      windDirection = getWindDirection(double.parse(weatherData['wind']['deg'].toString()));
      windSpeed = (double.parse(weatherData['wind']['speed'].toString()) * 3.6).toStringAsFixed(2);

      switch (weatherData['weather'][0]['main']) {
        case 'Clear':
          weatherIcon = WeatherIcons.day_sunny;
          break;
        case 'Clouds':
          weatherIcon = WeatherIcons.cloudy;
          break;
        case 'Rain':
          weatherIcon = WeatherIcons.rain;
          break;
        case 'Drizzle':
          weatherIcon = WeatherIcons.sprinkle;
          break;
        case 'Thunderstorm':
          weatherIcon = WeatherIcons.thunderstorm;
          break;
        case 'Snow':
          weatherIcon = WeatherIcons.snow;
          break;
        case 'Mist':
          weatherIcon = WeatherIcons.fog;
          break;
        case 'Smoke':
          weatherIcon = WeatherIcons.smoke;
          break;
        case 'Haze':
          weatherIcon = WeatherIcons.day_haze;
          break;
        case 'Dust':
          weatherIcon = WeatherIcons.dust;
          break;
        case 'Fog':
          weatherIcon = WeatherIcons.fog;
          break;
        case 'Sand':
          weatherIcon = WeatherIcons.sandstorm;
          break;
        case 'Ash':
          weatherIcon = WeatherIcons.volcano;
          break;
        case 'Squall':
          weatherIcon = WeatherIcons.strong_wind;
          break;
        case 'Tornado':
          weatherIcon = WeatherIcons.tornado;
          break;
        default:
          print('Unrecognized weather condition: ${weatherData['weather'][0]['main']}');
          weatherIcon = WeatherIcons.na;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WeatherCard(
          city: city,
          temperature: temperature,
          humidity: humidity,
          windDirection: windDirection,
          windSpeed: windSpeed,
          weatherIcon: weatherIcon,
        ),
      ],
    );
  }
}
