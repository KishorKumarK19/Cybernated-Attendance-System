import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
// import 'dart:html' as html;


class CsvPathsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context)  {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
final String? classname = args?['classname'] as String?;
final String? userid = args?['userid'] as String?;
    
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Attendance Records'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('CSV').doc(userid).collection('csv_files').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final csvPathsDocs = snapshot.data!.docs;
             final docNames = csvPathsDocs.map((doc) => doc.id).toList();
              
              return ListView.builder(
  itemCount: docNames.length,
  itemBuilder: (context, index) {

    final name = docNames[index];
    
    return ListTile(
      title: Text(name),
      onTap: () async {
        final csvPathDoc = csvPathsDocs[index];
        // Download the CSV file
           
           try {

        final CollectionReference collectionRef = FirebaseFirestore.instance.collection('CSV').doc(userid).collection('csv_files').doc(name).collection('data');
        QuerySnapshot querySnapshot=await collectionRef.get();
        
      final csvList = <List<dynamic>>[];

      


// Add the header row.
//final fieldNames = querySnapshot.docs.first.data().keys.toList();
//csvList.add(fieldNames);
//Replace with your desired field order
  


// Add the header row.
final fieldNames = ['Date','Name', 'Time of entry','Time of exit']; // replace with your desired field order
csvList.add(fieldNames);

// Add the data rows.
querySnapshot.docs.forEach((doc) {
  final rowValues = <dynamic>[];
  fieldNames.forEach((key) {
    final value = doc.get(key);
    rowValues.add(value);
  });
  csvList.add(rowValues);
});


//   Directory? externalDir = await getExternalStorageDirectory();
// String? dir = externalDir?.path;

// final directories = await getExternalStorageDirectories();
// final dir;
//   if (directories!.isNotEmpty) 
//     dir= directories[0].path + '/Documents';
//   } else {
//     throw Exception('Unable to access Documents directory');
//   }


Directory? dir;
dir = Directory("/storage/emulated/0/Download");

if (dir != null && await Permission.storage.request().isGranted) {
  // Do something with the directory path


    final file = File("${dir.path}/$name.csv");
    
    // Write the CSV data to the file
    final csvData = csvList.map((row) => row.join(',')).join('\n');
    await file.writeAsString(csvData);
}
    
    // Optional: Show a message to the user
    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: Text('File saved'),
          content: Text('The CSV file has been saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

// final csvString = const ListToCsvConverter().convert(csvList);

// final bytes = utf8.encode(csvString);

// final blob = html.Blob([bytes], 'text/csv');

// final url = html.Url.createObjectUrlFromBlob(blob);
// final link = html.AnchorElement(href: url)
//   ..download = '$name.csv' // Set a custom file name here
//   ..click();
// html.Url.revokeObjectUrl(url);
 //}          
 catch (e) {
  print('Error retrieving data: $e');
}
           



// Convert the data to a CSV string.
      },
    );
  },
);
            },
          ),
        );
      },
    );
  }
}
