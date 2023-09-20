import 'dart:async';
import 'dart:math';

import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationDetailPage extends StatefulWidget {
  final LocationDoc location;
  const LocationDetailPage({super.key, required this.location});

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

  Set<Marker> markers = {};

  Future<void> _goToYourLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    debugPrint(serviceEnabled.toString());
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    debugPrint(permissionGranted.toString());

    var currentLocation = await location.getLocation();

    log.i(currentLocation);

    final CameraPosition myLocation = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 19.151926040649414,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  addMarker() async {
    final id = Random().nextInt(10000);
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      final Marker marker = Marker(
        markerId: MarkerId("$id"),
        position: LatLng(widget.location.latitude, widget.location.longitude),
        infoWindow: const InfoWindow(title: "My Pin", snippet: '*'),
        onTap: () {
          log.i("$id Tap!");
        },
      );
      markers = {marker};
    });
  }

  @override
  void initState() {
    super.initState();
    _goToYourLocation();
    addMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "ข้อมูล ${widget.location.name}".text.minFontSize(18).make(),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }
}
