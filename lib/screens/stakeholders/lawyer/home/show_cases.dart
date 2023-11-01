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
    Timer? locationUpdateTimer;

    userStream.listen((User? user) {
      if (user != null) {
        locationUpdateTimer?.cancel(); // Cancel any existing timer
        locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
          Geolocator.getCurrentPosition().then((Position position) {
            uploadLocation(user.uid, position.latitude, position.longitude);
          });
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
          'username': username,
        });
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  Future<void> deleteComplaint(String complaintId) async {
    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(complaintId)
        .delete();
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
        title: const Text('Complaints List'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userRole = userData['userRole'];
                  final userName = userData['name'];
                  final userRegNo = userData['registrationNumber'];
                  if (userRole == 'student') {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Complaint Category: ${complaintData['Category']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Description:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('${complaintData['deScription']}'),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Complainant:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('$userName'),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Registration Number:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('$userRegNo'),
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
