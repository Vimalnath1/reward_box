import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reward_box/bluetooth.dart';
import 'package:reward_box/fitnessgoals.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:reward_box/screentime.dart';

void main() {
  /*if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request().then((status) {
  runApp( const MaterialApp(home: MyApp()));
  });
  } else {*/
      runApp(MaterialApp(home: MyApp()));
  //}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward Box"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 15,),
              Text("Hello Reward Box Users! We are so excited for you to use our product. On this app, you must connect to your Reward Box via Bluetooth and then choose which mode you want to use. This will track your progress on each mode and will open your box.",
              textAlign: TextAlign.center,
              ),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const BluetoothScreen()));
              }, child: Text("Connect to Device")),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const FitnessScreen()));
              }, child:Text("Fitness Mode")),
              ElevatedButton(onPressed: () {

              }, child:Text("Parental Mode")),
              ElevatedButton(onPressed: () {

              }, child:Text("Timer Mode")),
              ElevatedButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const LockboxScreen()));
              }, child:Text("Lockbox Mode")),
              ElevatedButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const ScreenTime()));
              }, child:Text("Screen Time Mode")),
          ]
          ),
      ),
    );
  }
}