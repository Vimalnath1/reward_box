import 'dart:isolate';

import 'package:duration/duration.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:health/health.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reward_box/util.dart';
import 'package:reward_box/main.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reward_box/utils/user_simple_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}
late TextEditingController controller;



// Future<void> openbox() async {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance; 
//   var connecteddevices=await flutterBlue.connectedDevices;
//   for (var device in connecteddevices){
//     if (device.localName=="Reward Box"){
//       //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
//       List<BluetoothService> services = await device.discoverServices();
//       services.forEach((service) async {
//         var characteristics = service.characteristics;
//         if (lockstatus==true){
// for(BluetoothCharacteristic c in characteristics) {
//     await c.write([0x74 , 0x72 , 0x75, 0x65]);
// }
//         }
//         else {
//           for(BluetoothCharacteristic c in characteristics) {
//               await c.write([0x66, 0x61, 0x6C, 0x73, 0x65]);
//           }
//         }
//       });
//     }
//   }
// }
class _FitnessScreenState extends State<FitnessScreen> {
  List<HealthDataPoint> _healthDataList = [];
  static final types = dataTypesAndroid;
    final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  String goal="";
  var stepgoalexists=false;
  var caloriegoalexists=false;
  late SharedPreferences preferences;
  
int goaltime=1;

  void initState(){
    
    super.initState();
    init();
    
  //goal=UserSimplePreferences.getFitnessGoal() ??"";
  
  
   controller=TextEditingController();
   }
  Future init() async {
    //await initializeService();
  //   await AndroidAlarmManager.initialize();
  //   await AndroidAlarmManager.periodic(const Duration(minutes: 2), 0, printHello,exact: true, // Set to true for precise timing
  // wakeup: true,);
    preferences=await SharedPreferences.getInstance();
    goal=preferences.getString("goal")!;
    print(preferences.getString("goal")!);
    getSteps();
    setState(()=> this.goal=goal);
    if (goal!=""){
    stepgoalexists=true;
    caloriegoalexists=true;
  }
  else{
    stepgoalexists=false;
    caloriegoalexists=false;
  }
  }
  void getSteps(){
    int? steptimestamp=preferences.getInt("time");
    if (steptimestamp!-(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).millisecondsSinceEpoch>0){
      stepdata=preferences.getInt("steps")!;
    }
    else{
      stepdata=0;
    }
    
    }
//  static void printHello() async {
//   final DateTime now = DateTime.now();
//   //setState(() {
//     stepdata=0;
//   //});
//   print("$stepdata $now");
//   //preferences.setInt("steps", stepdata);
// }



  Future <String?>openDialog(String title,int minimum)=> showDialog<String>(
  
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text(title),
    content: Column(children: [
      
      TextField(
      autofocus: true,
      decoration:InputDecoration(hintText: "Your goal must be greater than ${minimum.toString()}"),
      controller: controller,
    ),
    NumberPicker(minValue: 1, maxValue: 30, value: goaltime, 
      onChanged: (newvalue) => setState(() => goaltime = newvalue)
       ),
       Row(children: [IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = goaltime - 1;
                goaltime = newValue.clamp(1, 30);
              })),SizedBox(width:180 ),IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = goaltime + 1;
                goaltime = newValue.clamp(1, 30);
              })),],)
    ]
    ),
    actions: [
      TextButton(onPressed: () {
        if (int.parse(controller.text)>=minimum)
        {Navigator.of(context).pop(controller.text);}
      }, child: Text("Submit")),

    ],
  )
);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Mode"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            children: [
                SizedBox(height: 15,),
                Text("Choose the goal you want to achieve for the reward box to open. You can have a step goal or calorie goal",
                textAlign: TextAlign.center,
                ),
                ElevatedButton(onPressed: () async {
                  final goal= await openDialog("Step Goal",5000);
                  setState(()=>this.goal=goal!);
                  //print(goal);
                  preferences.setString("goal", goal!);
                  print("${preferences.getString("goal")} Weee");
                  //UserSimplePreferences.setFitnessGoal(goal!.toString());
                  setState(() {
                    stepgoalexists=true;
                  });
                }, child: Text("Step Goal")),
                ElevatedButton(onPressed: () async {
                  final goal= await openDialog("Calorie Goal",1000);
                  setState(()=>this.goal=goal!);
                  print(goal);
                  setState(() {
                    caloriegoalexists=true;
                  });
                  
                }, child: Text("Calorie Goal")),
                stepgoalexists?goalprogress("Step", goal,stepdata):Text(""),
                caloriegoalexists?goalprogress("Calorie", goal,caloriedata):Text(""),
                ElevatedButton(onPressed: () async {
                      await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }
                  print(preferences.getInt("steps"));
                  int? steps;
                  //steps=UserSimplePreferences.getsavedSteps()??0;
                  final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day).subtract(Duration(days:(goaltime-1)));

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]); 

    if (requested) {
      try {

        //print("Wahoo ${healthDataList[0].value}");
        

        steps=await health.getTotalStepsInInterval(midnight, now);
        
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      setState(() {
        stepdata = (steps == null) ? 0 : steps;
        preferences.setInt("time", DateTime.now().millisecondsSinceEpoch);
        preferences.setInt("steps", stepdata);
      });
    } else {
      print("Authorization not granted - error in authorization");

    }
                }, child: Text("Fetch Step Data")),
                ElevatedButton(onPressed: () async {
                  await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }
                  int? calories;
                  List<HealthDataPoint> healthDataList = [];
                  final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        healthDataList= await health.getHealthDataFromTypes(midnight, now,[HealthDataType.ACTIVE_ENERGY_BURNED]);
        print("Wahoo ${healthDataList}");
        calories=int.parse((healthDataList[0].value).toString()) ;
        
      } catch (error) {
        print("Caught exception in getting calories: $error");
      }

      print('Total number of steps: $calories');

      setState(() {
        caloriedata = (calories == null) ? 0 : calories;
        
      });
    } else {
      print("Authorization not granted - error in authorization");

    }
                }, child: Text("Fetch Calorie Data")),
            ]
          ),
        ),
      );
    }
  }

  Widget goalprogress(String goaltype, String goal,int data) {
    
    return Column(
      children: [
        Text("$goaltype Goal: $goal"),
        Text("$goaltype Left: ${(int.parse(goal)-data).toString()}"),
        ElevatedButton(onPressed: () {
          if ((int.parse(goal)-data)<=0){
            lockstatusfitness=true;
            openbox();
            
          }
        }, child: Text("Open Box"))
      ],
    );
  }