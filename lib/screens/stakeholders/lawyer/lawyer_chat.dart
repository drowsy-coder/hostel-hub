import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocatioDisplayScreen extends StatefulWidget {
  const LocatioDisplayScreen({Key? key}) : super(key: key);

  @override
  _LocatioDisplayScreenState createState() => _LocatioDisplayScreenState();
}

class _LocatioDisplayScreenState extends State<LocatioDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    fetchAuthorityLocations();
  }

  void fetchAuthorityLocations() {
    _firestore
        .collection('authority_locations')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        final uid = data['uid'];
        final username = data['username'];
        final userRole = data['userRole'];
        final latitude = data['latitude'];
        final longitude = data['longitude'];

        final marker = Marker(
          markerId: MarkerId(uid),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: username ?? 'Unknown Authority',
            snippet: userRole ?? 'Role not specified',
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Tracking"),
        actions: <Widget>[],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(12.8396339,
              80.1551999), // Set the initial camera position to your desired location
          zoom: 17, // Set the initial zoom level
        ),
        markers: _markers,
      ),
    );
  }
}
