import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_help/screens/stakeholders/lawyer/cardScreens/pdf_view.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AbsentStudentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absent Students'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadAbsentStudentsPDF(context);
            },
          ),
        ],
      ),
      body: AbsentStudentsList(),
    );
  }

  Future<List<Map<String, String>>?> getAbsentStudents() async {
    List<Map<String, String>> absentStudents = [];

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final usersCollection = FirebaseFirestore.instance.collection('users');
        final studentsQuery =
            usersCollection.where('userRole', isEqualTo: 'student');
        final studentsSnapshot = await studentsQuery.get();

        for (var studentDoc in studentsSnapshot.docs) {
          final studentUID = studentDoc['uid'];
          final attendanceCollection =
              FirebaseFirestore.instance.collection('attendance');
          final attendanceQuery =
              attendanceCollection.where('uid', isEqualTo: studentUID);
          final attendanceSnapshot = await attendanceQuery.get();

          if (attendanceSnapshot.docs.isEmpty) {
            final studentName = studentDoc['name'];
            final studentNo = studentDoc['registrationNumber'];
            absentStudents
                .add({'name': studentName, 'registrationNumber': studentNo});
          }
        }
      }
    } catch (error) {
      print("Error: $error");
    }

    return absentStudents;
  }

  Future<void> _downloadAbsentStudentsPDF(BuildContext context) async {
    final List<Map<String, String>>? absentStudents = await getAbsentStudents();

    if (absentStudents != null && absentStudents.isNotEmpty) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Absent Students'),
                ),
                pw.SizedBox(height: 10),
                for (int i = 0; i < absentStudents.length; i++)
                  pw.Text(
                      '${i + 1}. Name: ${absentStudents[i]['name']}, Registration Number: ${absentStudents[i]['registrationNumber']}'),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'absent_students.pdf';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PDFViewScreen(pdfFilePath: filePath),
        ),
      );
    }
  }
}

class AbsentStudentsList extends StatefulWidget {
  @override
  _AbsentStudentsListState createState() => _AbsentStudentsListState();
}

class _AbsentStudentsListState extends State<AbsentStudentsList> {
  Future<List<Map<String, String>>> getAbsentStudents() async {
    List<Map<String, String>> absentStudents = [];

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final usersCollection = FirebaseFirestore.instance.collection('users');
        final studentsQuery =
            usersCollection.where('userRole', isEqualTo: 'student');
        final studentsSnapshot = await studentsQuery.get();

        for (var studentDoc in studentsSnapshot.docs) {
          final studentUID = studentDoc['uid'];
          final attendanceCollection =
              FirebaseFirestore.instance.collection('attendance');
          final attendanceQuery =
              attendanceCollection.where('uid', isEqualTo: studentUID);
          final attendanceSnapshot = await attendanceQuery.get();

          if (attendanceSnapshot.docs.isEmpty) {
            final studentName = studentDoc['name'];
            final studentNo = studentDoc['registrationNumber'];
            absentStudents
                .add({'name': studentName, 'registrationNumber': studentNo});
          }
        }
      }
    } catch (error) {
      print("Error: $error");
    }

    return absentStudents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: getAbsentStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final absentStudents = snapshot.data;
          return ListView.builder(
            itemCount: absentStudents!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5, // Increase elevation for a stronger shadow
                margin: EdgeInsets.all(12), // Increase margin for more spacing
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Add rounded corners
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(
                      16), // Add padding for more space around the content
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/User Avatar.png'), // Add a user avatar image
                    radius: 30,
                  ),
                  title: Text(
                    '${absentStudents[index]['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make the name bold
                      fontSize: 18, // Increase font size
                    ),
                  ),
                  subtitle: Text(
                    'Reg. Number: ${absentStudents[index]['registrationNumber']}',
                    style: TextStyle(
                      color: Colors.grey, // Change subtitle text color
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.info), // Add an info icon to the right
                    onPressed: () {
                      // Add an action when the info icon is pressed
                      // You can show more details or perform an action here.
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
