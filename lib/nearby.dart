import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mygps/firebase_helper.dart';
import 'package:mygps/location_helper.dart';
import 'package:mygps/utils.dart';

class NearBy extends StatefulWidget{

  @override
  _NearByState createState() => new _NearByState();
}


class _NearByState extends State<NearBy>{
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<Widget> nearby = new List();
  Map<String,double> _currentLocation;

  @override
  initState(){
    super.initState();
    realTimeDb.addListener(_onMessage);
    locationHelper.addListener(_onLocationChange);
  }

  _onLocationChange(Map<String,double> location){
    setState(() {
      _currentLocation = location;
    });
  }

  _onMessage(QuerySnapshot snapshot){
    snapshot.documents.forEach((e)=>print(e.data));
    nearby.clear();
    setState(() {
      //nearby.add(ListTile(title: Text(message['name']),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: myDrawer(context),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(realTimeDb.name),
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black12)]
                    ),
                  ),
                ),
              ),

            ],
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nearby.clear();
  }
}