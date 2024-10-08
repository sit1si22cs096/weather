import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/additional_info_item.dart';
import 'package:weatherapp/constrants.dart';
import 'package:weatherapp/icon_as_per_weather.dart';
import 'package:weatherapp/weather_main_card.dart';
import 'package:weatherapp/weather_forcast_item.dart';

class WeatherAppHome extends StatefulWidget {
  const WeatherAppHome({super.key});

  @override
  State<WeatherAppHome> createState() => _WeatherAppHomeState();
}

class _WeatherAppHomeState extends State<WeatherAppHome> {
  TextEditingController textEditingController = TextEditingController();
  String cityName = "Nepal";
  Future<Map<String, dynamic>> getWeatherInfo(String country) async {
    String apikey = apiKey;
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$country&units=metric&APPID=$apikey";
    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw data["message"] ?? "An unexpected error occurred!";
      }
      return data;
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(98, 149, 132, 1),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(98, 149, 132, 1),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      hintText: "Please Enter a City",
                      prefixIcon: Icon(Icons.location_city),
                      prefixIconColor: Color.fromRGBO(226, 241, 236, 1),
                    ),
                  ),
                ),

                // button
                TextButton(
                  onPressed: () {
                    cityName = textEditingController.text;
                    cityName = cityName.isEmpty ? "Nepal" : cityName;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    elevation: 10,
                    backgroundColor: const Color.fromRGBO(256, 116, 120, 1),
                    maximumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "Check",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: getWeatherInfo(cityName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 5,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }

                final data = snapshot.data!;
                final currentTemp = data['list'][0]["main"]["temp"];
                final currentWeatherStatus =
                    data['list'][0]["weather"][0]['main'];
                IconData icon = getIcon(currentWeatherStatus);
                final currentHumidity = data['list'][0]["main"]["humidity"];
                final currentPressure = data['list'][0]["main"]["pressure"];
                final currentWind = data['list'][0]["wind"]["speed"];
                final forecastWeather = data['list'];

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            cityName,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        MainCard(
                          currentTemp: currentTemp,
                          icon: icon,
                          currentWeatherStatus: currentWeatherStatus,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Weather Forecast",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: List.generate(
                        //       20,
                        //       (index) {
                        //         final time = DateFormat('HH:mm').format(
                        //             DateTime.fromMillisecondsSinceEpoch(
                        //                 forecastWeather[index]["dt"] * 1000));
                        //         return WeatherForecastCard(
                        //             icon: getIcon(forecastWeather[index]
                        //                 ['weather'][0]['main']),
                        //             time: "$time UTC",
                        //             value:
                        //                 "${forecastWeather[index]['main']['temp']}");
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              final weather = forecastWeather[index + 1];
                              final time = DateFormat.Hm()
                                  .format(DateTime.parse(weather["dt_txt"]));
                              final weatherstatus =
                                  weather['weather'][0]['main'];
                              return WeatherForecastCard(
                                  icon: getIcon(weatherstatus),
                                  time: "$time UTC",
                                  value: "${weather['main']['temp']}",
                                  status: weatherstatus);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInformation(
                                icon: Icons.water_drop,
                                label: "Humidity",
                                value: "$currentHumidity %"),
                            AdditionalInformation(
                                icon: Icons.air,
                                label: "Wind Speed",
                                value: "$currentWind m/s"),
                            AdditionalInformation(
                                icon: Icons.thermostat,
                                label: "Pressure",
                                value: "$currentPressure hPa"),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
