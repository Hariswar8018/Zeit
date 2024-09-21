import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/training.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';
import 'package:location2/location2.dart';

class Google_F extends StatelessWidget {
  double lat;double lon;
  Google_F({super.key,required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return UltraMapPlacePicker(
      googleApiKey: 'AIzaSyBJQJDrsf-P7ZOYW0JsyLyXi_pot9vJMqw',
      initialPosition: LocationModel(lat, lon),
      mapTypes:(isHuaweiDevice)=>isHuaweiDevice?  [UltraMapType.normal]:UltraMapType.values,
      myLocationButtonCooldown: 1,
    resizeToAvoidBottomInset: false,enableMyLocationButton: true,enableMapTypeButton: true,
      useCurrentLocation: true,onPlacePicked: (PickResultModel){
      if (PickResultModel != null && PickResultModel.geometry != null) {
        Navigator.pop(context, {
          'lat': PickResultModel.geometry!.location.lat,
          'lng': PickResultModel.geometry!.location.lng,
          'address': PickResultModel.formattedAddress.toString(),
        });
      } else {
        print("PickResultModel or geometry is null");
      }
      print(PickResultModel.formattedAddress.toString());
      print("Starts here---->");
    },
    );
  }
}


class Google_S extends StatefulWidget {
  final double lat;
  final double lon;

  Google_S({super.key, required this.lat, required this.lon});

  @override
  _Google_SState createState() => _Google_SState();
}

class _Google_SState extends State<Google_S> {
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {}; // Added for markers
  late LatLng _initialPosition;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(widget.lat, widget.lon);
    _getUserLocation();
    _addMarker(); // Add the marker at the target location
  }

  _getUserLocation() async {
    setLocationSettings(
      rationaleMessageForGPSRequest: 'Please enable GPS to find your location.',
      rationaleMessageForPermissionRequest: 'Please grant location permission.',
      askForPermission: true,
    );
    try {
      final location = await getLocation();
      print("Location: ${location.latitude}, ${location.longitude}");
      _userLocation = LatLng(location.latitude!, location.longitude!);

      _addPolyline();
    } catch (e) {
      print("Failed to get user location: $e");
    }
  }

  _addPolyline() {
    if (_userLocation != null) {
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: [_userLocation!, _initialPosition],
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    }
  }

  _addMarker() async {
    // Load custom marker icon
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(14, 14)),
      'assets/7124723.png',
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('target_location'),
          position: _initialPosition,
          icon: customIcon, // Use the custom icon here
          infoWindow: InfoWindow(
            title: 'Target Location',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Navigate to Location", style: TextStyle(color: Colors.white, fontSize: 23)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded, color: Color(0xff1491C7), size: 22)),
            ),
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        polylines: _polylines,
        markers: _markers, // Add the markers to the map
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
