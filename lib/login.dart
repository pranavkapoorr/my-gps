import 'package:flutter/material.dart';
import 'package:mygps/firebase_helper.dart';
import 'package:mygps/location_helper.dart';
import 'package:mygps/nearby.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState()=> new _LoginState();
}
class _LoginState extends State{
  TextEditingController _controller = new TextEditingController();
  Map<String,double> _startLocation;

  @override
  void initState() {
    super.initState();
    realTimeDb.initCommunication();
    locationHelper.initCommunication();
  }

  @override
  Widget build(BuildContext context) {
    _startLocation = locationHelper.startLocation;

    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage("images/maps.gif",),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken)
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 2.0,
              color: Colors.white.withOpacity(0.81),
              child: Container(
                width: deviceSize.width/2,
                height: deviceSize.height/3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(image:AssetImage("images/logo.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(controller: _controller,decoration: new InputDecoration(labelText: "Enter Name",labelStyle: TextStyle(fontSize: 25.0,color: Colors.blue),fillColor: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: (){
                          realTimeDb.send(_controller.text, _startLocation['latitude']!=null?_startLocation['latitude']:0.0, _startLocation['longitude']!=null?_startLocation['longitude']:0.0);
                          Navigator.push(context, new MaterialPageRoute(builder: (context)=>new NearBy()));
                      },child: Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}