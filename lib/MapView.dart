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
  bool currentWidget = true;
  Map<String,double> _currentLocation;


  @override
  void initState() {
    super.initState();
    locationHelper.addListener(_onLocationChange);

  }

  _onLocationChange(Map<String,double> location){
    setState(() {
      _currentLocation = location;
    });
  }

  @override
  void dispose() {
    super.dispose();
    locationHelper.removeListener(_onLocationChange);
    _showDetails = false;
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
              ):Text('')

            ],
          )
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