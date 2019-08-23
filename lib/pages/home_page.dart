import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart' as ll;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

GoogleMapController mapController;

class _HomePageState extends State<HomePage> {
  var currentLocation = LocationData;
  var location = new Location();
  var lat, long, accuracy;

  var corlat = 23.547771;
  var corlong = 87.289857;

  var ovallat = 23.549896;
  var ovallong = 87.291763;

  var meter1, meter2;

  @override
  void initState() {
    super.initState();
    {
      location.changeSettings(accuracy: LocationAccuracy.HIGH);
      location.onLocationChanged().listen((LocationData currentLocation) {
        setState(() {
          lat = currentLocation.latitude;
          long = currentLocation.longitude;
          ll.Distance distance = new ll.Distance();
          meter1 = distance(
              new ll.LatLng(lat, long), new ll.LatLng(corlat, corlong));
          meter2 = distance(
              new ll.LatLng(lat, long), new ll.LatLng(ovallat, ovallong));
          accuracy = currentLocation.accuracy;
          // print(lat);
          // print(long);
        });
      });
    }
  }

  bool _isUp = true;

  var bottom = 70.0;
  var right = 10.0;
  var left = 10.0;
  var top = 470.0;

  var bottom2 = -10.0;
  var right2 = 0.0;
  var left2 = 0.0;
  var top2 = 590.0;

  var bottom3 = 630.0;
  var right3 = 0.0;
  var left3 = 0.0;
  var top3 = -10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Text("drawer"),
      ),
      // appBar: AppBar(
      //   title: Text("Home"),
      //   backgroundColor: Colors.black,
      // ),
      body: Stack(
        children: <Widget>[
          GameMap(),
          AnimatedPositioned(
            bottom: bottom3,
            right: right3,
            left: left3,
            top: top3,
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInCirc,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                curve: Curves.easeInCirc,
                opacity: _isUp ? 0.5 : 0.8,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   stops: [0.5, 1.0],
                    //   colors: [Colors.green, Colors.lightGreen],
                    // ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.black, Colors.grey],
                    ),
                    // color: Colors.black,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "INSTRUCTIONS",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom,
            right: right,
            left: left,
            top: top,
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInCirc,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                curve: Curves.easeInCirc,
                opacity: _isUp ? 0.7 : 0.0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Center(
                    child: Text(
                      "INTERFICIO",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom2,
            right: right2,
            left: left2,
            top: top2,
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInCirc,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                curve: Curves.easeInCirc,
                opacity: _isUp ? 0.5 : 0.8,
                child: GestureDetector(
                  onVerticalDragStart: (context) {
                    setState(() {
                      if (_isUp) {
                        bottom2 = -10.0;
                        right2 = 0.0;
                        left2 = 0.0;
                        top2 = 270.0;

                        bottom = 390.0;
                        right = 50.0;
                        left = 50.0;
                        top = 150;

                        bottom3 = 390.0;
                        right3 = 0.0;
                        left3 = 0.0;
                        top3 = -10.0;

                        _isUp = !_isUp;
                      } else {
                        bottom2 = -10.0;
                        right2 = 0.0;
                        left2 = 0.0;
                        top2 = 590.0;

                        bottom = 70.0;
                        right = 10.0;
                        left = 10.0;
                        top = 470;

                        bottom3 = 630.0;
                        right3 = 0.0;
                        left3 = 0.0;
                        top3 = -10.0;

                        _isUp = !_isUp;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    // margin: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Color(0xFF0091FF), Color(0xFF0059FF)],
                      ),
                      //color: Color(0xFF0091FF),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              leading: Text("LATITUDE: $lat"),
                            ),
                            ListTile(
                              leading: Text("LONGITUDE: $long"),
                            ),
                            ListTile(
                              leading: Text("ACCURACY: $accuracy"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom - 55,
            right: 20,
            left: 20,
            top: top + 75,
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInCirc,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  if (_isUp) {
                    bottom2 = -10.0;
                    right2 = 0.0;
                    left2 = 0.0;
                    top2 = 270.0;

                    bottom = 390.0;
                    right = 50.0;
                    left = 50.0;
                    top = 150;

                    bottom3 = 390.0;
                    right3 = 0.0;
                    left3 = 0.0;
                    top3 = -10.0;

                    _isUp = !_isUp;
                  } else {
                    bottom2 = -10.0;
                    right2 = 0.0;
                    left2 = 0.0;
                    top2 = 590;

                    bottom = 70.0;
                    right = 10.0;
                    left = 10.0;
                    top = 470;

                    bottom3 = 630.0;
                    right3 = 0.0;
                    left3 = 0.0;
                    top3 = -10.0;

                    _isUp = !_isUp;
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Image.asset("assets/leaderboard.png"),
                  SizedBox(
                    width: 110,
                  ),
                  Image.asset("assets/instructions.png")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.554079, 87.278687),
        zoom: 13,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      //mapType: MapType.hybrid,
      compassEnabled: true,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
