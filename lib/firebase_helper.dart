
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

FireBaseHelper realTimeDb = new FireBaseHelper();

class FireBaseHelper{
  final String _collectionName = "data";
  static final FireBaseHelper _db = new FireBaseHelper._internal();
  factory FireBaseHelper() => _db;
  FireBaseHelper._internal();
  bool _isOn = false;
  String name;
  double lat,long;

  final Firestore _firestore = new Firestore();
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }

  initCommunication() async {
    _isOn = true;
    _firestore.collection(_collectionName).snapshots().listen(
        _onReceptionOfMessageFromServer,
        onError: (error, StackTrace stackTrace){
          print("error!!!! $error");
        },
        onDone: (){
          // communication has been closed and removing from db

          _isOn = false;
        }
    );
  }

  send(String name,double lat, double long) async{
    this.name = name;
    this.lat = lat;
    this.long = long;
    await _firestore.collection(_collectionName).document(name).setData({"name":name,"lat":lat,"long":long}).whenComplete(()=>print("added")).catchError((e)=>print(e.toString()));
  }

  removeFromdB()async{
    await _firestore.collection(_collectionName).document(name).delete();
  }
  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message){
    _listeners.forEach((Function callback){
      callback(message);
    });
  }

}