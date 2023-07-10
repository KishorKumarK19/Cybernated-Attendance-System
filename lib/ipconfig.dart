import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ipconfig extends StatelessWidget {
  const ipconfig({super.key});

  @override
  Widget build(BuildContext context) {
    final _ipController=TextEditingController();
    return Scaffold(
      appBar: AppBar(title:Text("Configure IP")),
      body: Center(
        child:Column(children:[Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal:40.0),
              child: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: 'IP Address',
                ),
              ),
            ),
            SizedBox(height:20.0),
            ElevatedButton(
              onPressed: () => Navigator.pop(context,_ipController.text.trim()),
              child: Text('Set Target IP'),
            ),
            
            ])
      )
    );
  }
}
