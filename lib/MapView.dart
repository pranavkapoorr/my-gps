import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mygps/firebase_helper.dart';

import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mygps/location_helper.dart';

class MapView extends StatefulWidget{
  _MapViewState createState() => new _MapViewState();
}

class _MapViewState extends State<MapView>{
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _showDetails = false;
  bool _showPeople = false;
  bool currentWidget = true;
  Map<String,double> _currentLocation;
  List<Marker> _markers = new List();
  List<Widget> _people = new List();


  @override
  void initState() {
    super.initState();
    realTimeDb.addListener(_onMessageFromDb);
    locationHelper.addListener(_onLocationChange);

  }

  _onMessageFromDb(QuerySnapshot snapshot){
    _markers.clear();
    _people.clear();
    snapshot.documents.forEach((d){
      print(d.data);
      if(d.data['name']!=null && d.data['lat']!=null && d.data['long']!=null){
        setState(() {
          _markers.add(_buildMarker(d.data['name'],new LatLng(d.data['lat'], d.data['long'])));
          _people.add(ListTile(leading:CircleAvatar(child: Text(d.data['name'].toString().substring(0,1)),),title: Text(d.data['name']),));
          });
      }
    });
  }
  _onLocationChange(Map<String,double> location){
    setState(() {
      _currentLocation = location;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentLocation.clear();
    _markers.clear();
    realTimeDb.removeListener(_onMessageFromDb);
    locationHelper.removeListener(_onLocationChange);
    _showDetails = false;
    _showPeople = false;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;


    if (_currentLocation == null) {
      widgets = new List();
    } else{
      widgets = [];
    }
    widgets.add(new Center(child: Text("Description",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),));
    widgets.add(new Center(
        child: new Text(locationHelper.startLocation != null
            ? 'Start location: ${locationHelper.startLocation}\n'
            : 'Error: ${locationHelper.error}\n',style: TextStyle(color: Colors.white),)));

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: $_currentLocation\n'
            : 'Error: ${locationHelper.error}\n',style: TextStyle(color: Colors.white))));

    widgets.add(new Center(
        child: new Text(locationHelper.permission
            ? 'Has permission : Yes'
            : "Has permission : No",style: TextStyle(color: Colors.white))));


    return new Scaffold(
          key: _scaffoldKey,
          drawer: myDrawer(context),
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
                    markers: _markers
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
              ),
              Positioned(
                top: 24.0,right: 5.0,
                child: FloatingActionButton(
                  heroTag: "asd",
                    backgroundColor: Colors.black.withOpacity(0.1),
                    child: new Stack(
                      overflow: Overflow.visible,
                        children: <Widget>[
                          new Icon(Icons.person_pin_circle),
                          new Positioned(  // draw a red marble
                            top: -5.0,
                            right: -3.0,
                            child: Container(
                                decoration: BoxDecoration(color:Colors.redAccent,shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(_markers.length.toString(),style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),),
                                )
                            ),
                          )
                        ]
                    ),
                    onPressed: (){
                      if(_showPeople) {
                        setState(() {
                          _showPeople = false;
                        });
                      }else{
                        setState(() {
                          _showPeople = true;
                        });
                      }
                    }
                ),
              ),

              Positioned(
                  bottom: 24.0,
                  right: 5.0,
                  child: FloatingActionButton(
                    heroTag: null,
                      backgroundColor: Colors.black.withOpacity(0.1),
                      child: Icon(Icons.description,size: 30.0,),
                      onPressed: (){
                        if(_showDetails) {
                          setState(() {
                            _showDetails = false;
                          });
                        }else{
                          setState(() {
                            _showDetails = true;
                          });
                        }
                      }
                  )
              ),
              _showDetails?Positioned(
                bottom: 24.0,
                left: 5.0,
                child: new Container(
                  width: 250.0,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4),borderRadius: BorderRadius.circular(5.0)),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: widgets,
                  ),
                ),
              ):Text(''),

              _showPeople?Center(
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5.0)),
                    child: ListView(
                      children: _people,
                    ),
                  ),
                ),
              ):Text('')

            ],
          )
    );
  }


  Marker _buildMarker(String name,LatLng latLng) {
    return new Marker(
      point: latLng,
      width: 60.0,
      height: 55.0,
      anchor: AnchorPos.top,
      builder: (BuildContext context) =>
          CircleAvatar(child: Text(name.substring(0,1)),
          ),
    );
  }
}
//_buildMarker(new LatLng(_currentLocation['latitude'],
//_currentLocation['longitude'])),