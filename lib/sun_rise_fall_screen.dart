import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SunriseSunsetScreen extends StatefulWidget {
  const SunriseSunsetScreen({super.key});

  @override
  _SunriseSunsetScreenState createState() => _SunriseSunsetScreenState();
}

class _SunriseSunsetScreenState extends State<SunriseSunsetScreen> {
  String sunriseTime = '';
  String sunsetTime = '';

  final double latitude = 23.8103;
  final double longitude = 90.4125;

  Future<void> fetchSunriseSunset() async {
    final url =
        'https://api.sunrise-sunset.org/json?lat=$latitude&lng=$longitude&formatted=0';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final DateTime sunriseUtc = DateTime.parse(data['results']['sunrise']);
      final DateTime sunsetUtc = DateTime.parse(data['results']['sunset']);

      setState(() {
        sunriseTime = formatTime(sunriseUtc);
        sunsetTime = formatTime(sunsetUtc);
      });
    } else {
      throw Exception('Failed to load sunrise and sunset times');
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time.toLocal());
  }

  @override
  void initState() {
    super.initState();
    fetchSunriseSunset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunrise & Sunset Times'),
      ),
      body: sunriseTime.isEmpty && sunsetTime.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সূর্যদয়ের সময়: $sunriseTime',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'সূর্যাস্তের সময়: $sunsetTime',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
