import 'dart:async';
import 'package:cron/cron.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'networking.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.mobile);
  final int mobile;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Geolocator geolocator = Geolocator();
  Position position = Position();
  List<Position> coordinates = <Position>[];
  int count;
  String socialDistancing = ' ';
  @override
  void initState() {
    getLocation();
    // TODO: implement initState
    super.initState();
  }

  void callingApi() async {
    var data = await NetworkHelper().apiCall(widget.mobile,
        position.latitude.toString(), position.longitude.toString());
    print('printing data message ${data['message'][1]['latitude']}');
    for (int i = 0; i <= data['message'].length - 1; i++) {
      coordinates.add(Position(
        latitude: double.parse(data['message'][i]['latitude']),
        longitude: double.parse(data['message'][i]['longitude']),
      ));
    }
    setState(() {
      count = data['message'].length;
      print(count);
    });
    checkDistance();
  }

  void getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.whileInUse) {
      await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // coordinates.add(Position(latitude: position.latitude,longitude: position.longitude));
    callingApi();
  }

  Color colour;
  void checkDistance() async {
    var distance = 1.87;
    for (int i = 0; i <= count - 1; i++) {
      var distance1 = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          coordinates[i].latitude,
          coordinates[i].longitude);
      print(distance1);
      if (distance1 < distance) distance = distance1;
    }
    print(distance);
    setState(() {
      if (distance <= 0.93) {
        socialDistancing =
            'You\'re too close! Kindly maintain distance between each other.';
        colour = Colors.red;
        Vibration.vibrate(duration: 2000);
      } else if (distance <= 1.86) {
        socialDistancing =
            'You\'re exactly at 6ft of distance! please move away.';
        colour = Colors.orange;
      } else {
        socialDistancing = 'You\'re safe!';
        colour = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cron = Cron();
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      getLocation();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('OutPace'),
      ),
      body: Column(
        children: [
          Image(
            image: AssetImage('images/logo.png'),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            socialDistancing,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colour,
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
