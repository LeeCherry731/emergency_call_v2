import 'dart:async';
import 'dart:math';

import 'package:emergency_call_v2/config.dart';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
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

    await markMyLocation();
  }

  Future<void> _goToUserLocation() async {
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

    final CameraPosition myLocation = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 13,
    );

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  Future addMarker() async {
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

  Future markMyLocation() async {
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

  Future<void> findRoute() async {
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
        "AIzaSyAn4CzG9IwSiFHxu_hMxFNL66fnJYgQMaA", from, to);

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
        title: "ข้อมูล ${widget.location.title}".text.minFontSize(18).make(),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.location.getColor(),
            ),
            child: "${widget.location.getStatus()}".text.make(),
          )
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
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
          )
        },
        markers: markers,
      ),
      bottomSheet: mainCtr.userModel.value.role != Role.staff
          ? null
          : SizedBox(
              height: 320,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "เรื่อง: ${widget.location.title}".text.make(),
                              "ชื่อ: ${widget.location.name}".text.make(),
                              "อีเมล: ${widget.location.email}".text.make(),
                              "lat: ${widget.location.latitude}".text.make(),
                              "long: ${widget.location.longitude}".text.make(),
                              TextButton(
                                onPressed: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: widget.location.phone,
                                  );
                                  await launchUrl(launchUri);
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(width: 10),
                                    "เบอร์: ${widget.location.phone}"
                                        .text
                                        .underline
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      widget.location.picture,
                                      height: 200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SmartDialog.showLoading(msg: "Loading...");
                                    await _goToUserLocation();
                                    SmartDialog.dismiss();
                                  },
                                  child: "ตำแหน่งขอความช่วยเหลือ".text.make(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SmartDialog.showLoading(msg: "Loading...");
                                    await _goToMyLocation();
                                    SmartDialog.dismiss();
                                  },
                                  child: "ตำแหน่งของฉัน".text.make(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await findRoute();
                                  },
                                  child: "คำนวนเส้นทาง".text.make(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () async {
                                    SmartDialog.showLoading(msg: "Loading...");
                                    mainCtr.staffChooseLocation(
                                        id: widget.location.id);
                                    SmartDialog.dismiss();
                                    Get.back();
                                  },
                                  child: "เลือก".text.make(),
                                ),
                              ),
                            ],
                          ),
                          if (widget.location.status == "going")
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      mainCtr.staffSuccess(
                                          id: widget.location.id);
                                    },
                                    child:
                                        "ยืนยันการช่วยเหลือสำเร็จ".text.make(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      mainCtr.staffFailed(
                                          id: widget.location.id);
                                    },
                                    child: "ยืนยันการช่วยเหลือไม่สำเร็จ"
                                        .text
                                        .make(),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
