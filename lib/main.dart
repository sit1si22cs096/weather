import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  String temperature = '';
  String city = '';
  String description = '';
  String error = '';
  bool loading = false;

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      loading = true;
      error = '';
    });

    final apiKey = "e1a572348595514e796b2c1a985c7ddf";
    final url = "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          temperature = data['main']['temp'].toString();
          description = data['weather'][0]['description'];
          city = data['name'];
          loading = false;
        });
      } else {
        setState(() {
          error = data['message'];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Failed to fetch weather.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => fetchWeather(_controller.text),
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            if (loading) CircularProgressIndicator(),
            if (temperature.isNotEmpty && description.isNotEmpty)
              Column(
                children: [
                  Text('City: $city', style: TextStyle(fontSize: 20)),
                  Text('Temperature: $temperature °C', style: TextStyle(fontSize: 20)),
                  Text('Description: $description', style: TextStyle(fontSize: 20)),
                ],
              ),
            if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}