import 'dart:async';

import 'package:emergency_call_v2/controllers/home.ctr.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationDetailPage extends StatefulWidget {
  const LocationDetailPage({super.key});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(13.768566, 100.3425051),
    zoom: 14.4746,
  );

  final location = Location();

  Future<void> _goToYourLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    debugPrint(serviceEnabled.toString());
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    debugPrint(_permissionGranted.toString());

    var currentLocation = await location.getLocation();

    log.i(currentLocation);

    final CameraPosition _myLocation = CameraPosition(
      target:
          LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
      zoom: 19.151926040649414,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "ข้อมูล location".text.minFontSize(18).make(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        log.i("floatingActionButton");
      }),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
