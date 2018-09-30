import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mygps/MapView.dart';
import 'package:mygps/nearby.dart';


Widget myDrawer(BuildContext context) => Drawer(
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
      new ListTile(leading: Icon(Icons.people),title: Text("NearBy"),trailing: Icon(Icons.navigate_next),onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>new NearBy()));
      },),
      new Divider(height: 0.0, color: Colors.grey ),
      new ListTile(leading: Icon(Icons.map),title: Text("MapView"),trailing: Icon(Icons.navigate_next),onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>new MapView()));
      },),
      new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey ),
      new ListTile(leading: Icon(Icons.person),title: Text("Account"),trailing: Icon(Icons.navigate_next),),
      new Divider(height: defaultTargetPlatform == TargetPlatform.iOS ? 5.0 : 0.0, color: Colors.grey),
      new ListTile(leading: Icon(Icons.help),title: Text("Help"),trailing: Icon(Icons.navigate_next),),
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
);