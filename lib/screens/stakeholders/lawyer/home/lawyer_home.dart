import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<List<String>> getAbsentStudents() async {
    List<String> absentStudents = [];

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
            absentStudents.add(studentName);
          }
        }
      }
    } catch (error) {
      print("Error: $error");
    }

    return absentStudents;
  }

  Future<void> _downloadAbsentStudentsPDF(BuildContext context) async {
    final List<String> absentStudents = await getAbsentStudents();

    final pdf = pw.Document();

    for (var i = 0; i < absentStudents.length; i++) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Absent Students',
                ),
              ),
              pw.SizedBox(
                  height:
                      10),
              pw.Text('${i + 1}. ${absentStudents[i]}'),
            ],
          );
        },
      ));
    }

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

class AbsentStudentsList extends StatefulWidget {
  @override
  _AbsentStudentsListState createState() => _AbsentStudentsListState();
}

class _AbsentStudentsListState extends State<AbsentStudentsList> {
  Future<List<String>> getAbsentStudents() async {
    List<String> absentStudents = [];

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
            absentStudents.add(studentName);
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
    return FutureBuilder<List<String>>(
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
                elevation: 3,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(absentStudents[index]),
                ),
              );
            },
          );
        }
      },
    );
  }
}
