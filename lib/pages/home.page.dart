import 'dart:async';

import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexPage = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 221, 221, 221),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: const Stack(
          children: [
            Positioned(child: MapSample()),
            Positioned.fill(
              child: HomeContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<String> options = [
    "เหตุด่วนเหตุร้าย",
    "อุบัติเหตุฉุกเฉิน",
    "แจ้งเหตุไฟไหม้"
  ];
  String? option;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromRadius(100),
            shape: const CircleBorder(),
            shadowColor: Colors.black87,
            backgroundColor: Colors.red,
            elevation: 1,
          ),
          onPressed: () {
            debugPrint("press");
          },
          child: "SOS".text.minFontSize(80).make(),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Card(
              child: RadioListTile<String?>(
                value: options[0],
                groupValue: option,
                activeColor: Colors.purpleAccent,
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() {
                      option = val;
                    });
                  }
                },
                title:
                    options[0].text.minFontSize(18).color(Colors.black).make(),
              ),
            ),
            Card(
              child: RadioListTile<String?>(
                value: options[1],
                groupValue: option,
                activeColor: Colors.purpleAccent,
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() {
                      option = val;
                    });
                  }
                },
                title:
                    options[1].text.minFontSize(18).color(Colors.black).make(),
              ),
            ),
            Card(
              child: RadioListTile<String?>(
                value: options[2],
                groupValue: option,
                activeColor: Colors.purpleAccent,
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() {
                      option = val;
                    });
                  }
                },
                title:
                    options[2].text.minFontSize(18).color(Colors.black).make(),
              ),
            ),
          ],
        )
        // const SizedBox(height: 10),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(20),
        //     ),
        //   ),
        //   child: "เหตุด่วนเหตุร้าย"
        //       .text
        //       .minFontSize(24)
        //       .color(Colors.redAccent)
        //       .make(),
        // ),
        // const SizedBox(height: 10),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(20),
        //     ),
        //   ),
        //   child: "อุบัติเหตุฉุกเฉิน"
        //       .text
        //       .minFontSize(24)
        //       .color(Colors.redAccent)
        //       .make(),
        // ),
        // const SizedBox(height: 10),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(20),
        //     ),
        //   ),
        //   child: "แจ้งเหตุไปไหม้"
        //       .text
        //       .minFontSize(24)
        //       .color(Colors.redAccent)
        //       .make(),
        // ),
      ],
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.768566, 100.3425051),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  final location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: Container(
        height: Get.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/images/bg_hospital.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(),
      ),
      // body: GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: printLog,
          child: const Icon(
            Icons.pin_drop_outlined,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
    );
  }

  printLog() {
    log.i("message");
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

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

    debugPrint(currentLocation.toString());

    final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target:
          LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
