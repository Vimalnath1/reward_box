import 'package:flutter/material.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:reward_box/main.dart';

class TimerMode extends StatefulWidget {
  const TimerMode({super.key});

  @override
  State<TimerMode> createState() => _TimerModeState();
}

class _TimerModeState extends State<TimerMode> {
  late TextEditingController controller;
  int timertime=0;
  String minutes="";
  @override
  void initState() {
     controller=TextEditingController();
    super.initState();

  }
  Future openDialog()=> showDialog(
  
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text("Set Timer"),
    content:
      TextField(
      autofocus: true,
      decoration:InputDecoration(hintText: "Set timer length in minutes"),
      controller: controller,
    ),
    actions: [
     TextButton(onPressed: () {
        {Navigator.of(context).pop(controller.text);}
        controller.clear();

      }, child: Text("Submit")),

    ],
  )
);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer Mode"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 15,),
              Text("Here you can set however long the timer will be",
              textAlign: TextAlign.center,
              ),
              ElevatedButton(onPressed: () async {
                final minutes=await openDialog();
                setState(()=>this.minutes=minutes!);
                print(minutes);
                timerprogress=[];
                timerprogress+=stringtohex("p");
                timerprogress+=stringtohex("t");
                timerprogress+=stringtohex("(");
                timerprogress+=stringtohex(minutes);
                timerprogress+=stringtohex(")");
                //String hourascii=String.fromCharCode(int.parse(hour));
                // for (int i=0;i<hour.length;i++){
                // int asciivalue=hour.codeUnitAt(i);
                // setState(() {
                //   timerhex.add(asciivalue.toRadixString(16));
                // });
                
                // };
                
                openbox();
              }, child: Text("Set Timer")),
              
              
          ]
          ),
      ),
    );
  }
}