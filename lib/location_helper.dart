import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

LocationHelper locationHelper = new LocationHelper();

class LocationHelper {
  static final LocationHelper _loc = new LocationHelper._internal();

  factory LocationHelper() => _loc;

  LocationHelper._internal();

  bool _isOn = false;

  Map<String, double> startLocation;
  Map<String, double> currentLocation;
  bool permission = false;
  String error;

  Location _location = new Location();
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  initCommunication() async {
    _isOn = true;
    initPlatformState();
    _location.onLocationChanged().listen(
        _onChangeOfLocation,
        onError: (error, StackTrace stackTrace) {
          print("error!!!! $error");
        },
        onDone: () {
          // communication has been closed
          _isOn = false;
        }
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      permission = await _location.hasPermission();
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
      startLocation = location;
  }


  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onChangeOfLocation(message) {
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}

