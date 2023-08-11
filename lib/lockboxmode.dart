import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockboxScreen extends StatefulWidget {
  const LockboxScreen({super.key});

  @override
  State<LockboxScreen> createState() => _LockboxScreenState();
}
Future<SharedPreferences> prefs=SharedPreferences.getInstance();
bool lockstatus=false;

Future<void> openbox() async {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance; 
  var connecteddevices=await flutterBlue.connectedDevices;
  for (var device in connecteddevices){
    if (device.name=="Reward Box"){
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) async {
        var characteristics = service.characteristics;
        if (lockstatus==true){
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65]);
}
print(lockstatus);
 Timer(Duration(milliseconds: 10000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65]);
          }
        }
      });
    }
  }
}
    
class _LockboxScreenState extends State<LockboxScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Lockbox Mode"),
        centerTitle: true,
      ),
      body: Center(
        child: 
            LockSwitch()  
        )
    );
  }
}
class LockSwitch extends StatefulWidget {
  const LockSwitch({super.key});

  @override
  State<LockSwitch> createState() => _LockSwitchState();
}

class _LockSwitchState extends State<LockSwitch> {
  @override
  Widget build(BuildContext context) {
    
    return Switch(value: lockstatus,  onChanged:(bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          //final SharedPreferences preference = await prefs;
          lockstatus = value;
          openbox();
          // Timer(Duration(milliseconds: 60000), () {
          //   if (lockstatus){
          //     lockstatus=false;
          //     openbox();
          //   }
          //   else{

          //   }
          // });
          
          //preference.setBool("lockstatus", value);
        });
          
      },
    );
  }
}
    