import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:reward_box/main.dart';

class LockboxScreen extends StatefulWidget {
  const LockboxScreen({super.key});

  @override
  State<LockboxScreen> createState() => _LockboxScreenState();
}
Future<SharedPreferences> prefs=SharedPreferences.getInstance();
bool lockstatus=false;
bool lockstatusfitness=false;
bool lockstatusscreentime=false;
Future<void> openbox() async {
  
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance; 
  var connecteddevices=await flutterBlue.connectedDevices;
  for (var device in connecteddevices){
    if (device.localName=="Reward Box"){
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
      List<BluetoothService> services = await device.discoverServices();
      
      services.forEach((service) async {
        var characteristics = service.characteristics;
        if (custom! && fitness==false && screentime==false){
        if (lockstatus==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65, 0x63]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
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
        }
        else if (custom! && fitness! && screentime==false){
if (lockstatus==true &&lockstatusfitness==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x63,0x66]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
        else if (custom==false && fitness! && screentime==false){
          if (lockstatusfitness==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x66]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
        else if (custom==false && fitness==false && screentime!){
          if (lockstatusscreentime==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x73]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
        else if (custom==false && fitness! && screentime!){
          if (lockstatusscreentime==true && lockstatusfitness==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x66,0x73]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
        else if (custom! && fitness! && screentime!){
          if (lockstatusscreentime==true && lockstatusfitness==true && lockstatus==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x66,0x73,0x63]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
        else if (custom! && fitness==false && screentime!){
          if (lockstatusscreentime==true && lockstatus==true){
          
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 , 0x75, 0x65,0x73,0x63]);
}

print(lockstatus);
 Timer(Duration(milliseconds: 600000), () async {
            for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65,]);
          }
          });
        }
        else {
          for(BluetoothCharacteristic c in characteristics) {
              await c.write([0x66, 0x61, 0x6C, 0x73, 0x65, ]);
          }
        }
        }
      });
    }
  }
}



class _LockboxScreenState extends State<LockboxScreen> {
  late final LocalAuthentication auth;
  bool canauth=false;
  bool authenticated=false;
  late TextEditingController controller;
  List<Widget> choretiles=[];
  Map chorelist={};
  
  late SharedPreferences preferences;
  List<String> chorenames=[];
  void initState(){
    init();
    controller=TextEditingController();
      super.initState();
      auth=LocalAuthentication();
      auth.isDeviceSupported().then((bool isSupport) => setState(() {
        canauth=isSupport;
      },));
    }
    Future init() async {
      preferences=await SharedPreferences.getInstance();
      if (preferences.getStringList("chorenames")!=null){
        chorenames=preferences.getStringList("chorenames")!;
      }
      for (var chore in chorenames){
        chorelist[chore]=false;
        choretiles.add(addchore(chore, chorelist[chore]));
      }
    }
    Future<void> getbiometrics() async{
      List<BiometricType> availablebio=await auth.getAvailableBiometrics();
      print("$availablebio");
    }
    Widget addchore(String chorename,bool value){
  return ListTile(
    trailing: Checkbox(
  value: value,
   onChanged: (bool? newvalue) { 
    setState((){
        chorelist[chorename]=newvalue!;
        choretiles[chorenames.indexOf(chorename)]=addchore(chorename, newvalue);
    });
        print(newvalue);
        print(chorelist);
      }),
  title:Text(chorename),
  leading: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle delete button tap here
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Item'),
                      content: Text('Are you sure you want to delete this item?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              choretiles.removeAt(chorenames.indexOf(chorename));
                              chorenames.remove(chorename);
                              chorelist.remove(chorename);
                            });
                            preferences.setStringList("chorenames",chorenames );
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }
  )
  );
}
    Future openchecklistDialog()=> showDialog(
  
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text("Add chore"),
    content:Column(children: [
      TextField(
      autofocus: true,
      decoration:InputDecoration(hintText: "Type chore"),
      controller: controller,
    ),
    
      ]
    ), 
    actions: [
     TextButton(onPressed: () {
        Navigator.of(context).pop(controller.text);
        controller.clear();
      }, child: Text("Submit")),

    ],
  )
);

  @override
  Widget build(BuildContext context) {
     void initState(){
      super.initState();
      auth=LocalAuthentication();
      auth.isDeviceSupported().then((bool isSupport) => setState(() {
        canauth=isSupport;
      },));
    }
    Future<void> authenticate() async{
    int checks=0;
    setState(() {
          chorelist.forEach((key, value) {
            if (value==false){
              checks=1;
            }
          });
          if (checks==1){
            lockstatus=false;
            
          }
          else{
            lockstatus=true;
            
          }
          
          
        });
    try {
    authenticated=await auth.authenticate(
      localizedReason:
        "Authenticate to unlock the box",
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true
      ),
    );
    if (authenticated){
      openbox();
    }
    }
    on PlatformException catch(e){
      print(e);
    }
  }
    return Scaffold(
      appBar: AppBar(
        title: Text("Parental Mode"),
        centerTitle: true,
      ),
      body: choretiles.isEmpty? Center(
        child:
              Text("Press the plus in the corner to add a chore you want your child to complete"),
              //LockSwitch(),
        )
        :Column(children:[
        ListView.builder(
          shrinkWrap: true,
          itemCount: choretiles.length,
          itemBuilder: (context, index) {
            
            return choretiles[index];
          },
          ),
          
        
          ElevatedButton(child: Text("Submit"),onPressed: () {
            
            authenticate();

          }
          )
        ]
        )
        
        ,
      floatingActionButton:FloatingActionButton(child:Icon(Icons.add),onPressed: () async {
        final chore=await openchecklistDialog();
        setState(() {
        chorenames.add(chore);
        chorelist[chore]=false;
        choretiles.add(addchore(chore,chorelist[chore]));
        preferences.setStringList("chorenames", chorenames);
        });

        }
      ),
    
    );
  }
}
// class LockSwitch extends StatefulWidget {
//   const LockSwitch({super.key});

//   @override
//   State<LockSwitch> createState() => _LockSwitchState();
// }

// class _LockSwitchState extends State<LockSwitch> {
//   late final LocalAuthentication auth;
//   bool canauth=false;
//   bool authenticated=false;
 
//   @override
  
//   Widget build(BuildContext context) {
    
    
//     return Switch(value: lockstatus,  onChanged:(bool value) {
//       if (lockstatus==false){
//         authenticate();
//         // This is called when the user toggles the switch.
//         if (authenticated){
//         setState(() {
//           //final SharedPreferences preference = await prefs;
//           lockstatus = value;
//           openbox();
          
//         });
//     }
//     else{
//       setState(() {
//           //final SharedPreferences preference = await prefs;
//           lockstatus = false;
//           openbox();
          
//         });
//     }
//       }
//       else{
//     setState(() {
//           //final SharedPreferences preference = await prefs;
//           lockstatus = value;
//           openbox();
          
//         });
//   }
//   }
    
//     );
    
//   }
  
// }
    
