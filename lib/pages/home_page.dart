import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_flutter_finalapp/consts.dart';
import 'package:weather_flutter_finalapp/pages/seven_day_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  static const String _chosenCity = "delhi";

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(_chosenCity).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("1WEATHER"),
        centerTitle: true,
        backgroundColor: _getAppBarColor(), // Set app bar color dynamically
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchDialog(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(), // Ensure the container fills the entire screen
        child: _buildUI(),
      ),
    );
  }

  Color _getAppBarColor() {
    Color backgroundColor;
    String weatherIcon = _weather?.weatherIcon ?? '';

    // Set app bar color based on weather type
    if (weatherIcon.contains("01")) {
      backgroundColor = Colors.orange.shade300; // Orange gradient for sunny weather
    } else if (weatherIcon.contains("02") || weatherIcon.contains("03") || weatherIcon.contains("04")) {
      backgroundColor = Colors.grey.shade400; // Grey gradient for cloudy weather
    } else if (weatherIcon.contains("09") || weatherIcon.contains("10") || weatherIcon.contains("11")) {
      backgroundColor = Colors.indigo.shade400; // Indigo gradient for rainy weather
    } else if (weatherIcon.contains("13")) {
      backgroundColor = Colors.blue.shade300; // Blue gradient for snowy weather
    } else if (weatherIcon.contains("50")) {
      backgroundColor = Colors.teal.shade400; // Teal gradient for misty weather
    } else {
      backgroundColor = Colors.lightBlueAccent[200]!; // Default color or fallback
    }

    return backgroundColor;
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Color backgroundColor;
    String weatherIcon = _weather?.weatherIcon ?? '';

    // Set background color based on weather type
    if (weatherIcon.contains("01")) {
      backgroundColor = Colors.orange.shade300; // Orange gradient for sunny weather
    } else if (weatherIcon.contains("02") || weatherIcon.contains("03") || weatherIcon.contains("04")) {
      backgroundColor = Colors.grey.shade400; // Grey gradient for cloudy weather
    } else if (weatherIcon.contains("09") || weatherIcon.contains("10") || weatherIcon.contains("11")) {
      backgroundColor = Colors.indigo.shade400; // Indigo gradient for rainy weather
    } else if (weatherIcon.contains("13")) {
      backgroundColor = Colors.blue.shade300; // Blue gradient for snowy weather
    } else if (weatherIcon.contains("50")) {
      backgroundColor = Colors.teal.shade400; // Teal gradient for misty weather
    } else {
      backgroundColor = Colors.lightBlueAccent[200]!; // Default color or fallback
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withOpacity(0.5),
            backgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weather?.areaName ?? "",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, d MMMM y').format(_weather!.date!),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Image.network(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png",
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Text(
                _weather?.weatherDescription ?? "",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForecastScreen(city: _chosenCity)),
                      );
                    },
                    icon: Icon(Icons.more_vert_outlined),
                    label: Text("Seven Day Forecast"),
                  ),
                  Text(
                    DateFormat('h:mm a').format(_weather!.date!),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildExtraInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Extra Info",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem("Max Temp", "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C"),
            _buildInfoItem("Min Temp", "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C"),
            _buildInfoItem("Wind Speed", "${_weather?.windSpeed?.toStringAsFixed(0)}m/s"),
            _buildInfoItem("Humidity", "${_weather?.humidity?.toStringAsFixed(0)}%"),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) async {
    String? result = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _searchController = TextEditingController();
        return AlertDialog(
          title: Text("Search City"),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Enter city name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _searchController.text.trim());
              },
              child: Text("Search"),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      _searchCity(result);
    }
  }

  void _searchCity(String cityName) {
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }
}
