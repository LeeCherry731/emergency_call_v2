import 'dart:async';
import 'dart:math';
import 'package:emergency_call_v2/controllers/home.ctr.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationAdd extends StatefulWidget {
  const LocationAdd({super.key});

  @override
  State<LocationAdd> createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  double zoom = 17.0;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(13.768566, 100.3425051),
    zoom: 14,
  );

  LatLng myPoint = const LatLng(0, 0);

  final location = Location();

  Future<void> _goToYourLocation() async {
    SmartDialog.showLoading(msg: "Loading...");
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

    var currentLocation = await location.getLocation();

    log.i(currentLocation);

    CameraPosition myLocation = CameraPosition(
      target:
          LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
      zoom: zoom,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
    SmartDialog.dismiss();
  }

  void showBottomSheet() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Get.bottomSheet(Container(
        color: Colors.amber,
      ));
    }
  }

  Set<Marker> myMarker = {
    // Marker(
    //   markerId: MarkerId("value1"),
    //   position: LatLng(13.768566, 100.3425051),
    //   infoWindow: InfoWindow(title: "${13.768566}, ${100.3425051}"),
    //   icon: BitmapDescriptor.defaultMarker,
    //   onTap: () {
    //     log.i("value1 Tap!");
    //   },
    // ),
    // const Marker(
    //   markerId: MarkerId("value1"),
    //   position: LatLng(13.768566, 100.34),
    // ),
  };

  addMarker(LatLng point) async {
    log.i(point);
    final id = Random().nextInt(10000);
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      myPoint = point;

      final Marker marker = Marker(
        markerId: MarkerId("$id"),
        position: LatLng(
          point.latitude,
          point.longitude,
        ),
        infoWindow: const InfoWindow(title: "My Pin", snippet: '*'),
        onTap: () {
          log.i("$id Tap!");
        },
      );
      myMarker = {marker};
    });

    final CameraPosition myLocation = CameraPosition(
      target: LatLng(point.latitude, point.longitude),
      zoom: zoom,
    );
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // _goToYourLocation();
    // showBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Mark your location".text.minFontSize(18).make(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            mapToolbarEnabled: true,
            buildingsEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: addMarker,
            markers: myMarker,
            // markers: Set.of(listMarkers),
            zoomControlsEnabled: true,
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: Icon(Icons.pin_drop_rounded),
                          onPressed: () {
                            _goToYourLocation();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            homeCtr.addLocation(myPoint);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              myMarker = {};
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    width: Get.width,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Lat : ${myPoint.latitude}".text.size(20).make(),
                          const SizedBox(height: 10),
                          "Long : ${myPoint.longitude}".text.size(20).make()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
    );
  }
}
