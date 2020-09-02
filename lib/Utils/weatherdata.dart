import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  http.Response response;
  double lat, lon;

  String _temp, _cityName, _wind;
  String _lastDayTemp = "";
  String _nextDayTemp = "";
  String _humidity = "", _pressure = "";
  String _weather = "";
  String _day = "";

  static const String _API_KEY = "70cd1a9882826b9d2d2f7a0e3544290a";

  WeatherData(this.lat, this.lon);

  getTemp() async {
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_API_KEY&units=imperial";
    var response = await http.get(url);
    if (response.statusCode == 400) return;
    var decodedJson = jsonDecode(response.body);

    _temp = decodedJson["main"]["temp"].toString();
    _cityName = decodedJson["name"];
    _wind = decodedJson["wind"]["speed"].toString();
    _weather = decodedJson["weather"][0]["description"].toString();
    _humidity = decodedJson["main"]["humidity"].toString();
    _pressure = decodedJson["main"]["pressure"].toString();
    _day = getDay(DateTime.now().day);
  }

  getLastDayTemp() async {
    DateTime date = DateTime.now();
    int lastDateint =
        date.subtract(Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000;
    String lastDate = lastDateint.toString();
    String url =
        "https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$lat&lon=$lon&dt=$lastDate&appid=$_API_KEY&units=imperial";

    var response = await http.get(url);
    if (response.statusCode == 400) return;
    var decodedJson = jsonDecode(response.body);
    _lastDayTemp = decodedJson["current"]["temp"].toString();
  }

  getNextDayTemp() async {
    String url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,current&appid=$_API_KEY&units=imperial";
    var response = await http.get(url);
    if (response.statusCode == 400) {
      return;
    }
    var decodedJson = jsonDecode(response.body);
    _nextDayTemp = decodedJson["daily"][1]["temp"]["day"].toString();
  }

  String get temperature => _temp;
  String get cityName => _cityName;
  String get wind => _wind;
  String get humidity => _humidity;
  String get weather => _weather;
  String get pressure => _pressure;
  String get day => _day;
  String get lastDayTemp => _lastDayTemp;
  String get nextDayTemp => _nextDayTemp;

  String getDay(int day) {
    switch (day) {
      case 0:
        return "Sunday";
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "";
    }
  }
}
