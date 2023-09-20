import 'dart:async';
import 'dart:math';

import 'package:emergency_call_v2/config.dart';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
    zoom: 13,
  );

  final location = Location();
  LatLng currentLocation = const LatLng(0.0, 0.0);

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];

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

    final cur = await location.getLocation();

    currentLocation = LatLng(cur.latitude ?? 0, cur.longitude ?? 0);

    final CameraPosition myLocation = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 13,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  Future<void> _goToMyLocation() async {
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

    final cur = await location.getLocation();

    currentLocation = LatLng(cur.latitude ?? 0, cur.longitude ?? 0);

    final CameraPosition myLocation = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 13,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  addMarker() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      final Marker marker = Marker(
        markerId: const MarkerId("sss"),
        position: LatLng(widget.location.latitude, widget.location.longitude),
        infoWindow: const InfoWindow(title: "ที่อยู่เหตุด่วน", snippet: '*'),
        onTap: () {},
      );
      markers = {marker};
    });
  }

  markMyLocation() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      final Marker marker = Marker(
        markerId: const MarkerId("vvv"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: const InfoWindow(
          title: "ที่อยู่ปัจจุบัน",
          snippet: '*',
        ),
        onTap: () {},
      );
      markers = {marker, ...markers};
    });
  }

  Future<void> goToPoint() async {
    final PolylinePoints poly = PolylinePoints();

    final from = PointLatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );
    final to = PointLatLng(
      widget.location.latitude,
      widget.location.longitude,
    );

    final PolylineResult result = await poly.getRouteBetweenCoordinates(
        "AIzaSyBG1czcWgot1iEkNTFkz2Bg_BAZueBvaiM", from, to);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
  }

  Future<void> getIp() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data.toString());
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      print(exception.message);
    }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              getIp();
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              markMyLocation();
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () {
              _goToMyLocation();
            },
          ),
          FloatingActionButton(
            onPressed: () {
              goToPoint();
            },
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
          )
        },
        markers: markers,
      ),
    );
  }
}
