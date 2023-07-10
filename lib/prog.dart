import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  final _classController = TextEditingController();
  late String ip;
  Home({Key? key}) : super(key: key);
  

  void _runScript(String? userid) async {

    final classname=_classController.text.trim();  
    try{
    final response = await http.get(Uri.parse('http://$ip:5000/run-script?name=$classname&userid=$userid'));
    }
    catch(e)
    {
      print(e);
    }
    print('success');

  }

void _stopScript(String? userid) async {
   final classname=_classController.text.trim();
   
    try{
      final response = await http.get(Uri.parse('http://$ip:5000/stopit'));
      
    }
    catch(e)
    {
      print("Error Connecting to Server $e");  
    }    
  }

  void _csvlist(BuildContext context,String? userid) {
    
     final classname=_classController.text.trim();
     Navigator.pushNamed(context, '/CsvPathsScreen',arguments: {'classname': classname, 'userid': userid});
    //Navigator.pushNamed(context,'/fire_camera');
   
  }

  

Future<void> _signout(BuildContext context) async  {
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    }
    catch(e)
    {
      print("Error Signing out");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
final String? username = args?['username'] as String?;
final String? userid = args?['userid'] as String?;
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Cybernated Attendance System")),
        body: Center(
          child: Column(
              children:[Text("Welcome $username"),SizedBox(height:10.0),TextField(
              controller: _classController,
              
              decoration: InputDecoration(
                labelText: 'Class',
              ),
            ),
            SizedBox(height:10.0),
              ElevatedButton(
            onPressed:  () => _runScript(userid),
            child: Text("Take Attendance")),
            SizedBox(height:10.0),
            ElevatedButton(
            onPressed: () => _stopScript(userid),
            child: Text("Stop Attendance")),
            SizedBox(height:10.0),
            ElevatedButton(
            onPressed: () => _csvlist(context,userid),
            child: Text("See Attendance")),
            SizedBox(height:10.0),
            ElevatedButton(
            onPressed: () => _signout(context),
            child: Text("Sign Out")),
            SizedBox(height:10.0),
            GestureDetector(
      onTap: () {
        
        Future<Object?> myFuture =  Navigator.pushNamed(context, '/IP');
myFuture.then((result) {
  ip = result.toString();
  // Do something with myString
});
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          'Configure IP of System',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,          
          ),
        ),
      ),
    ),

            ],)
          ),
        ),
      );
  }
}