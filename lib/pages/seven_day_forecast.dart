import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_flutter_finalapp/consts.dart';
import 'package:weather_flutter_finalapp/pages/seven_day_forecast.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key, required this.city}) : super(key: key);

  final String city;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  List<Weather>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast(widget.city);
  }

  Future<void> _fetchForecast(String city) async {
    List<Weather> forecast = await _wf.fiveDayForecastByCityName(city);
    setState(() {
      _forecast = forecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("7-Day Forecast for ${widget.city}"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent[200],
        foregroundColor: Colors.white,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent.shade200,
              Colors.lightBlueAccent.shade400,
            ],
          ),
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    if (_forecast == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        _buildExtraInfo(),
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: _forecast!.length,
            itemBuilder: (context, index) {
              Weather forecastItem = _forecast![index];
              return _ForecastItem(forecast: forecastItem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExtraInfo() {
    if (_forecast == null || _forecast!.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if forecast is null or empty
    }

    Weather currentWeather = _forecast!.first;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              _buildInfoItem("Max Temp", "${currentWeather.tempMax?.celsius?.toStringAsFixed(0)}° C"),
              _buildInfoItem("Min Temp", "${currentWeather.tempMin?.celsius?.toStringAsFixed(0)}° C"),
              _buildInfoItem("Wind Speed", "${currentWeather.windSpeed?.toStringAsFixed(0)}m/s"),
              _buildInfoItem("Humidity", "${currentWeather.humidity?.toStringAsFixed(0)}%"),
            ],
          ),
        ],
      ),
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

  // Update forecast when city changes
  @override
  void didUpdateWidget(ForecastScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.city != oldWidget.city) {
      _fetchForecast(widget.city);
    }
  }
}

class _ForecastItem extends StatelessWidget {
  final Weather forecast;

  const _ForecastItem({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = forecast.date!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              DateFormat("EEEE").format(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              DateFormat("h:mm a").format(date),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Image.network(
              "http://openweathermap.org/img/wn/${forecast.weatherIcon}@2x.png",
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10.0),
            Text(
              "${forecast.temperature?.celsius?.toStringAsFixed(0)}° C",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
