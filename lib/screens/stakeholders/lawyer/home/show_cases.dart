import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class ComplaintsListView extends StatefulWidget {
  @override
  _ComplaintsListViewState createState() => _ComplaintsListViewState();
}

class _ComplaintsListViewState extends State<ComplaintsListView> {
  List<int> selectedComplaints = [];
  List<QueryDocumentSnapshot> complaints = [];
  late StreamSubscription<Position> positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    startLocationTracking();
  }

  void startLocationTracking() {
    Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
    userStream.listen((User? user) {
      if (user != null) {
        positionStreamSubscription =
            Geolocator.getPositionStream().listen((Position position) {
          uploadLocation(user.uid, position.latitude, position.longitude);
        });
      }
    });
  }

  void uploadLocation(String uid, double latitude, double longitude) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        String username = userDoc['name'];
        String role = userDoc['designation'];

        FirebaseFirestore.instance
            .collection('authority_locations')
            .doc(uid)
            .set({
          'uid': uid,
          'userRole': role,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': FieldValue.serverTimestamp(),
          'username': username, // Include the username in the location data
        });
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  void removeSelectedComplaints() {
    selectedComplaints.sort((a, b) => b.compareTo(a));
    for (var index in selectedComplaints) {
      complaints.removeAt(index);
    }
    setState(() {
      selectedComplaints.clear();
    });
  }

  @override
  void dispose() {
    positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          complaints = snapshot.data!.docs;
          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaintData =
                  complaints[index].data() as Map<String, dynamic>;
              final complaintUserUid = complaintData['userId'];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(complaintUserUid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userRole = userData['userRole'];
                  final userName = userData['name'];
                  final userRegNo = userData['registrationNumber'];
                  if (userRole == 'student') {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          complaints.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'Complaint Category: ${complaintData['Category']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'Description:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '${complaintData['deScription']}',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Complainant:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '$userName',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Registration Number:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                '$userRegNo',
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: selectedComplaints.contains(index),
                            onChanged: (bool? checked) {
                              if (checked != null) {
                                setState(() {
                                  if (checked) {
                                    selectedComplaints.add(index);
                                  } else {
                                    selectedComplaints.remove(index);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
            },
          );
        },
      ),
    );
  }
}