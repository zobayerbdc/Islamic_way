import 'package:flutter/material.dart';
import 'package:flutter_islamic_way/sun_rise_fall_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namaz Times',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NamazTimesScreen(),
    );
  }
}

class NamazTimesScreen extends StatefulWidget {
  const NamazTimesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NamazTimesScreenState createState() => _NamazTimesScreenState();
}

class _NamazTimesScreenState extends State<NamazTimesScreen> {
  Map<String, String> prayerTimes = {};
  String formatTime(String time) {
    final dateTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(dateTime);
  }

  Future<void> fetchPrayerTimes() async {
    const url =
        'http://api.aladhan.com/v1/timingsByCity?city=Jhalokathi&country=Bangladesh&method=2';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        prayerTimes = {
          'Fajr': formatTime(data['data']['timings']['Fajr']),
          'Sunrise': formatTime(data['data']['timings']['Sunrise']),
          'Dhuhr': formatTime(data['data']['timings']['Dhuhr']),
          'Asr': formatTime(data['data']['timings']['Asr']),
          'Maghrib': formatTime(data['data']['timings']['Maghrib']),
          'Isha': formatTime(data['data']['timings']['Isha']),
        };
      });
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Times'),
      ),
      body: prayerTimes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: prayerTimes.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text(entry.value),
                );
              }).toList(),
            ),
    );
  }
}
