import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

void main() => runApp(new MyApp());



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState()=>new _MyAppState();
}


class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  bool _useDarkTheme = false;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Image image1;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();


      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }


    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;


    if (_currentLocation == null) {
      widgets = new List();
    } else {
      widgets = [
        new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyBMMvOUAWOALCyDYymBfqSvfqdy_IIKQco")
      ];
    }

    widgets.add(new Center(
        child: new Text(_startLocation != null
            ? 'Start location: $_startLocation\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: $_currentLocation\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_permission
            ? 'Has permission : Yes'
            : "Has permission : No")));


    return new MaterialApp(
      title: 'my-gps',
      theme: _useDarkTheme==true?ThemeData.dark():ThemeData.light().copyWith(primaryColor: Colors.grey,),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldKey,
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                      accountName: new Text('Pranav Kapoor', style: new TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                      accountEmail: new Text('pranavkapoorr@gmail.com',
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.normal)),
                      currentAccountPicture: new CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: new Icon(
                          Icons.account_circle, size: 50.0, color: Colors.white,
                        ),
                      ), //Circle Avatar
                    ),
                    new Divider(height: 0.0, color: Colors.grey ),
                    new ListTile(leading: Icon(Icons.people),title: Text("NearBy"),trailing: Icon(Icons.navigate_next),),
                    new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey ),
                    new ListTile(leading: Icon(Icons.person),title: Text("Account"),trailing: Icon(Icons.navigate_next),),
                    new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey),
                    new ListTile(leading: Icon(Icons.help),title: Text("Help"),trailing: Icon(Icons.navigate_next),),
                    new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey),
                    ListTile(leading: Icon(Icons.highlight),title: Text("Dark Theme"),trailing: new Switch(value: _useDarkTheme, onChanged: (bool value){
                      setState(() {
                        print(value);
                        _useDarkTheme = value;
                      });
                    })),
                    new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey),
                    new AboutListTile(
                      applicationIcon: FlutterLogo(
                        colors: Colors.blueGrey,
                      ),
                      icon: Icon(Icons.info),
                      aboutBoxChildren: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Developed By Pranav Kapoor",
                        ),
                        Text(
                          "pranavkapoorr",
                        ),
                      ],
                      applicationName: "my-gps",
                      applicationVersion: "1.0.0",
                      applicationLegalese: "Apache License 2.0",
                    )
                  ],
                ),
              ),
              body: Stack(
                children: <Widget>[
                  _currentLocation != null ? new FlutterMap(
                    options: new MapOptions(
                      center: new LatLng(_currentLocation['latitude'],
                          _currentLocation['longitude']),
                      zoom: 15.0,
                    ),
                    layers: [
                      new TileLayerOptions(
                        urlTemplate: "https://maps.api.sygic.com/tile/{apiKey}/{z}/{x}/{y}",
                        additionalOptions: {
                          'apiKey': 'ffDgde5rCn6jjR35GJWD82hUC',
                        },
                      ),

                      new MarkerLayerOptions(
                        markers: [
                          _buildMarker(new LatLng(_currentLocation['latitude'],
                              _currentLocation['longitude'])),
                        ],
                      ),
                    ],
                  ) : Center(child: CircularProgressIndicator(),
                  ),
                  Positioned(
                      top: 24.0,left: 5.0,
                      child: FloatingActionButton(
                        backgroundColor: Colors.black.withOpacity(0.1),
                        child: Icon(Icons.menu,size: 30.0,),
                        onPressed: (){
                          _scaffoldKey.currentState.openDrawer();
                        }
                        ),
                      )

                ],
              )
            /*new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              )*/
      ),
    );
  }

  Marker _buildMarker(LatLng latLng) {
    return new Marker(
      point: latLng,
      width: 60.0,
      height: 55.0,
      anchor: AnchorPos.top,
      builder: (BuildContext context) =>
          CircleAvatar(backgroundImage: NetworkImage(
              "https://scontent.fyyz1-1.fna.fbcdn.net/v/t1.0-1/p320x320/11230099_10206835592669367_2911893136176495642_n.jpg?_nc_cat=111&oh=005e87a02bccaf399b5152534993298c&oe=5C2A1D27")),
    );
  }
}