import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/Utils/location.dart';
import 'package:weatherapp/Utils/weatherdata.dart';
import 'package:loading/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String temp = "", lastDayTemp = "", nextDayTemp = "";
  String city = "", wind = "", weather = "";
  String day = "", humidity = "", pressure = "";
  bool isVisibleMainWidget = false;

  void initialize() async {
    LocationService locationService = new LocationService();
    if (!await locationService.isPermissionGranted()) {
      await locationService.enableLocation();
    }
    if (!await locationService.isPermissionGranted()) {
      SystemNavigator.pop();
    }
    WeatherData weatherData = new WeatherData(
        await locationService.getCurrentLatitude(),
        await locationService.getCurrentLongitute());
    print(await locationService.getCurrentLatitude());
    await weatherData.getTemp();
    await weatherData.getLastDayTemp();
    await weatherData.getNextDayTemp();

    setState(() {
      temp = weatherData.temperature;
      lastDayTemp = weatherData.lastDayTemp;
      city = weatherData.cityName;
      wind = weatherData.wind;
      weather = weatherData.weather.toUpperCase();
      day = weatherData.day;
      humidity = weatherData.humidity;
      pressure = weatherData.pressure;
      nextDayTemp = weatherData.nextDayTemp;
      isVisibleMainWidget = true;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        elevation: 0,
        // actions: [IconButton(icon: null, onPressed: null)],
      ),
      body: loadingWidget(),
    );
  }

  Widget loadingWidget() {
    return Visibility(
      visible: !isVisibleMainWidget,
      replacement: mainWidget(),
      child: Container(
        child: Center(
          child: Loading(
              indicator: BallPulseIndicator(), size: 100.0, color: Colors.pink),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return tempWidget();
  }

  Column tempWidget() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: mainBgGradientWidget(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  mainTempWIdget(),
                  detailHeader(),
                  detailScrollWidget()
                ],
              ),
            ),
          ),
        ),
        Expanded(
          // flex: 1,
          child: Column(
            children: [
              listTile("YESTERDAY", lastDayTemp),
              Divider(
                color: Colors.purple,
              ),
              listTile("TOMORROW", nextDayTemp),
            ],
          ),
        ),
      ],
    );
  }

  Expanded listTile(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Center(
          child: ListTile(
            title: Text(
              "$title",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              "$value °C",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView detailScrollWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          detailWidget(WeatherIcons.humidity, "Humidity", humidity),
          detailWidget(WeatherIcons.wind, "wind", wind),
          detailWidget(WeatherIcons.small_craft_advisory, "pressure", pressure),
        ],
      ),
    );
  }

  Container mainTempWIdget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            child: AutoSizeText(
              "$temp °C",
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 100,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            "$weather",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text("Today is $day"),
        ],
      ),
    );
  }

  BoxDecoration mainBgGradientWidget() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple[700], Colors.purple[200]],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
    );
  }

  Widget detailHeader() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        "DETAIL",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  Container detailWidget(IconData iconData, String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.height / 4,
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.purple),
        color: Color.fromARGB(
            50, Colors.purple.red, Colors.purple.green, Colors.purple.blue),
      ),
      child: Column(
        children: [
          Expanded(
            child: Icon(
              iconData,
              size: 50,
            ),
          ),
          Text(title.toUpperCase()),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              value,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
