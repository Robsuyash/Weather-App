import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/Additionalinfoitem.dart';
import 'package:weather_app/Hourlyweather.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/serect.dart';
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openweatherAPIKey'),
            // 'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openweatherAPIKey'),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        // throw 'Aiennnnnnn!!! ho gaya';
        throw data['message'];
      }
      // temp = data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getCurrentLocation();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currweatherdata = data['list'][0];
          final currentTemperature = currweatherdata['main']['temp'];
          final currsky = currweatherdata['weather'][0]['main'];
          final currentPressure = currweatherdata['main']['pressure'];
          final currentWindSpeed = currweatherdata['wind']['speed'];
          final currentHumidity = currweatherdata['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemperature ° K',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Icon(
                                currsky == 'Clear'
                                    ? Icons.wb_sunny
                                    : currsky == 'Clouds'
                                        ? Icons.cloud
                                        : currsky == 'Rain'
                                            ? Icons.water_sharp
                                            : Icons.cloudy_snowing,
                                size: 65,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                currsky,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         Hourlyweather(
                //           time: data['list'][i + 1]['dt_txt'],
                //           temperature: data['list'][i+1]['main']['temp'].toString(),
                //           icon: data['list'][i+1]['weather'][0]['main'] == 'Clear'
                //                     ? Icons.wb_sunny
                //                     : currsky == 'Clouds'
                //                         ? Icons.cloud
                //                         : currsky == 'Rain'
                //                             ? Icons.water_sharp
                //                             : Icons.cloudy_snowing,
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);
                        // print(time);
                        return Hourlyweather(
                          time: DateFormat.j().format(time),
                          temperature: data['list'][index + 1]['main']['temp']
                              .toString(),
                          icon: data['list'][index + 1]['weather'][0]['main'] ==
                                  'Clear'
                              ? Icons.wb_sunny
                              : currsky == 'Clouds'
                                  ? Icons.cloud
                                  : currsky == 'Rain'
                                      ? Icons.water_sharp
                                      : Icons.cloudy_snowing,
                        );
                      },
                    ),
                  ),
                ), 

                //weather forcast
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Additionalinfoitems(
                      icon: Icons.water_drop_sharp,
                      title: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    Additionalinfoitems(
                      icon: Icons.air,
                      title: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    Additionalinfoitems(
                      icon: Icons.beach_access,
                      title: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
