import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

BluetoothDevice device1;
BluetoothDevice device2;
BluetoothState state;
BluetoothDeviceState deviceState;
//TODO; GO BACK AND SET THIS TO THE USER'S DATA
var mySignal = 903818839;

@override
void initState() {
  //var initState = super.initState();

//checks bluetooth current state

  FlutterBlue.instance.state.listen((state) {
    if (state == BluetoothState.off) {
//Alert user to turn on bluetooth.

    } else if (state == BluetoothState.on) {
//if bluetooth is enabled then go ahead.
//Make sure user's device gps is on.

      scanForDevices();
    }
  });
}

void scanForDevices() async {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  @override
  List<BluetoothDevice> _addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
    }
    return devicesList;
  }
}

BluetoothDevice singalInteraction() {
  var bluetoothInstance;
  List<ScanResult> scanResult = new List<ScanResult>();
  var scan = bluetoothInstance.scan().listen((scanResult));
  for (var b in scan) {
    if (b.device.name == "your_device_name") {
      device2 = b.device;
      createRecord(device2);
    }
  }
  print("found device");

  return device2;
}

void createRecord(var sigB) async {
  final databaseReference = FirebaseFirestore.instance;
  Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  var now = new DateTime.now();
  await databaseReference
      .collection("Interactions")
      .doc("S3UJBOETMFJoK0g1TXzi")
      .set({
    'Place': position,
    'Signal A': mySignal,
    'Signal B': sigB,
    'Time': now
  });

  DocumentReference ref = await databaseReference.collection("books").add({
    'title': 'Flutter in Action',
    'description': 'Complete Programming Guide to learn Flutter'
  });
  //print(ref.doc);
}

/*
abstract class GeofenceRegion {
  final String id;
  final Location location;
  final double radius;
  final List<GeofenceEvents> triggers;
  final AndroidGeofencingSettings androidSettings;

   GeofenceRegion(
    this.id, double latitude, double longitude, this.radius, this.triggers,
    {AndroidGeofencingSettings androidSettings});
}

abstract class GeofencingPlugin {

  static const MethodChannel _channel = const MethodChannel('plugins.flutter.io/geofencing_plugin');


  static Future<bool> initialize() async {
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    await _channel.invokeMethod('GeofencingPlugin.initializeService', <dynamic>[callback.toRawHandle()]);
  }

  static Future<bool> registerGeofence(
    GeofenceRegion,

    void Function(List<String> id, Location location, GeofenceEvent event) callback);
    if (Platform.isIOS &&
        region.triggers.contains(GeofenceEvent.dwell) &&
        (region.triggers.length == 1)) {
      throw UnsupportedError("iOS does not support 'GeofenceEvent.dwell'");
    }


    static Future<bool> removeGeofence(GeofenceRegion region);

    static Future<bool> removeGeofenceByID(String id) async;
}

class FlutterBlueApp extends StatelessWidget {
  final String deviceA;
  final String deviceB;

  FlutterBlueApp({Key key, this.deviceA, this.deviceB})
      : super(key: key);

  var thisInstant = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

*/
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  // ignore: deprecated_member_use
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
