import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:duration/duration.dart';

import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

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
class ScreenTime extends StatefulWidget {
  const ScreenTime({super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}
String appname="";
List<String> searchapps=[];

Widget appbutton(var title,var appicon){
  return ElevatedButton(onPressed: () {
    
    appname=title.toString();
  }, child: Text("meow"));
}
class _ScreenTimeState extends State<ScreenTime> {
  List<AppUsageInfo> _infos = [];
  List<Widget> appbuttons=[];
  bool pressed=false;
  late TextEditingController controller;
  String goal="";
 
  @override
  void initState() {
     controller=TextEditingController();
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);

      
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }
    Future openDialog(var apps)=> showDialog(
  
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text("Set Goal"),
    content:Column(children: [
      IconButton(icon: Icon(Icons.search),onPressed: () {showSearch(context: context, delegate: CustomSearchDelegate());},),
      TextField(
      autofocus: true,
      decoration:InputDecoration(hintText: "Set goal time in hours"),
      controller: controller,
    ),
      ]
    ), 
    actions: [
     TextButton(onPressed: () {
        {Navigator.of(context).pop(controller.text);}
      }, child: Text("Submit")),

    ],
  )
);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen Time Mode"),
        centerTitle: true,
      ),
      body:Center(
        child: Column(
          children: [
            SizedBox(height: 15,),
              Text("Press the button below to search for the app and set a timer for your goal.",
              textAlign: TextAlign.center,
              ),
            ElevatedButton(onPressed: () async {
              List<AppInfo> apps = await InstalledApps.getInstalledApps(true, false);
              for (var app in apps){
                searchapps.add((app.name).toString());
              }
              final goal=await openDialog(appbuttons);
              setState(()=>this.goal=goal!);
              setState(() {
                pressed=true;
              });
        }, child: Text("Set Goal")),

        pressed?
        Column(children: [
          ElevatedButton(onPressed: () {getUsageStats();}, child: const Text("Get Screen Time Data"))
          ,ElevatedButton(onPressed: () async {
          List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
          int appindex=0;
          for (var app in apps){
                if (appname==app.name){
                  appindex=apps.indexOf(app);
                }
              }
          for (var info in _infos) {
            if (info.packageName==apps.elementAt(appindex).packageName){
              List<String> gettingtime=info.usage.toString().split("");
              int time=0;
              time+=int.parse(gettingtime[0])*60;
              time+=int.parse(gettingtime[2]+gettingtime[3]);
              print(time);
              if (time<(int.parse(goal)*60)){
                lockstatus=true;
              }
              else{
                lockstatus=false;
              }
              openbox();
            } 
          }
          },child:Text("Open Box"))])

        :Text(""),
       ] ),),
      
            
    );
  }
}
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: () {
        query="";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
        close(context, null);
      }, icon: Icon(Icons.arrow_back));
    
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery=[];
    for (var app in searchapps){
      if (app.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(app);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) { 
        var result=matchQuery [index]; 
        return ListTile( 
          title: Text(result),
          
        ); // ListTile
      },
    );
  } 

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery=[];
    for (var app in searchapps){
      if (app.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(app);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) { 
        var result=matchQuery [index]; 
        return ListTile( 
          title: Text(result),
          onTap: () {
            appname=result;
            print(appname);
            Navigator.of(context).pop();
          },
        ); // ListTile
      },
    );
  }

}