import 'dart:async';
import 'dart:math';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
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
  final formKey = GlobalKey<FormState>();
  final emailCtr = TextEditingController();
  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final titleCtr = TextEditingController();

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

  Set<Marker> myMarker = {};

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

    // final CameraPosition myLocation = CameraPosition(
    //   target: LatLng(point.latitude, point.longitude),
    //   zoom: zoom,
    // );
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();

    emailCtr.text = mainCtr.userModel.value.email;
    nameCtr.text =
        "${mainCtr.userModel.value.firstname} ${mainCtr.userModel.value.lastname}";
    phoneCtr.text = mainCtr.userModel.value.phone;
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
                          child: const Icon(Icons.pin_drop_rounded),
                          onPressed: () {
                            _goToYourLocation();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            // mainCtr.addLocation(myPoint);
                            Get.bottomSheet(Container(
                              height: 500,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      "เรื่อง".text.size(20).make(),
                                      TextFormField(
                                        controller: titleCtr,
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "เรื่อง",
                                          fillColor: Colors.white70,
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      const SizedBox(height: 10),
                                      "อีเมล".text.size(20).make(),
                                      TextFormField(
                                        controller: emailCtr,
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "อีเมล",
                                          fillColor: Colors.white70,
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      const SizedBox(height: 10),
                                      "ชื่อ".text.size(20).make(),
                                      TextFormField(
                                        controller: nameCtr,
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "ชื่อ",
                                          fillColor: Colors.white70,
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      const SizedBox(height: 10),
                                      "เบอร์โทร".text.size(20).make(),
                                      TextFormField(
                                        controller: phoneCtr,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "เบอร์โทร",
                                          fillColor: Colors.white70,
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (myMarker.isEmpty) {
                                                mainCtr.snackError(
                                                  title: "Error",
                                                  msg: "กรุณาเลือกที่อยู่",
                                                );
                                                return;
                                              }
                                              await mainCtr.addLocation(
                                                myPoint,
                                                email: emailCtr.text,
                                                name: nameCtr.text,
                                                title: titleCtr.text,
                                                phone: phoneCtr.text,
                                              );
                                              Get.back();
                                            },
                                            child: "แจ้งเหตุ".text.make(),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: "ยกเลิก".text.make(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          child: const Icon(Icons.delete),
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
