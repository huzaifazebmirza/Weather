import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather/secret.dart'; // Make sure you have this import available
import 'package:weather/horly_forcast.dart'; // Make sure you have this import available
import 'package:intl/intl.dart';

class weather_screen extends StatefulWidget {
  weather_screen({super.key});

  @override
  State<weather_screen> createState() => _weather_screenState();
}

class _weather_screenState extends State<weather_screen> {
  String cityname = 'Multan';
  String temp = ''; // Store the temperature here

  Future<Map<String, dynamic>> get_Weather_api(
      String cityname, String key) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityname&APPID=$key'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return data; // Return the weather data
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
      throw Exception('Failed to fetch weather data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black54,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Weather App",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {

                  setState(() {
                    get_Weather_api('Multan', '20aca9266031f646cc543cbc2c5aeb3e');
                  });
                },
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
          body: FutureBuilder(
              future: get_Weather_api("Multan", '20aca9266031f646cc543cbc2c5aeb3e'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data as Map<String, dynamic>?;

                if (data == null) {
                  return Center(child: Text('No data available'));
                }

                final mainData = data['main'] as Map<String, dynamic>?;
                final currentTemperature =
                ((mainData?['temp'] - 273.15) as double).toStringAsFixed(2);
                final current_sky = data['weather'][0]['main'];
                final humidity = mainData?['humidity'];
                final wind_speed = data['wind']['speed'];
                final current_pressure = mainData?['pressure'];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.grey.shade900,
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "$currentTemperature° C",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Icon(
                                current_sky == 'Smoke' || current_sky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  " $current_sky",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Weather Forcast",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                     SizedBox(height: 8),
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child:   Row(
    children: [
      HourlyForecastItem(time: "12:00", temperature: "40.5", icon: Icons.sunny),
      HourlyForecastItem(time: "3:00", temperature: "41.3", icon:Icons.sunny ),
      HourlyForecastItem(time: '6:00', temperature: '35.03', icon: Icons.cloud),
      HourlyForecastItem(time: '9:00', temperature: '32.9', icon: Icons.cloud),
    ],
  ),
),
                   


                    
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Additional Information",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          // card Start

                          Card(
                            color: Colors.black54,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$humidity",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Card END

                          SizedBox(
                            width: 70,
                          ),

                          Card(
                            color: Colors.black54,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.air_outlined,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Wind Speed",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$wind_speed",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 70,
                          ),

                          Card(
                            color: Colors.black54,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.beach_access,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Pressure",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$current_pressure",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
