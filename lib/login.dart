import 'package:flutter/material.dart';
import 'package:mygps/MapView.dart';
import 'package:mygps/websocket.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState()=> new _LoginState();
}
class _LoginState extends State{
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    sockets.initCommunication();
    sockets.addListener(_onMessage);
  }

  _onMessage(message){
    if(message.toString().contains("successfully added")){
      print('added name');
      Navigator.push(context, new MaterialPageRoute(builder: (context)=>new MapView()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Stack(
        children: <Widget>[
          Image.asset("images/maps.gif",
            colorBlendMode: BlendMode.darken,
            color: Colors.black45,
            scale: 0.0,
            fit: BoxFit.cover,
          ),
          Center(
            child: Card(
              elevation: 2.0,
              color: Colors.white.withOpacity(0.81),
              child: Container(
                width: MediaQuery.of(context).size.width/1.5,
                height: MediaQuery.of(context).size.height/2.5,
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
                        sockets.send('{"name":"'+_controller.text+'"}');
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