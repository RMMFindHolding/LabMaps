import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  final Location _location = Location();

  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  LatLng? location;

  Future enableService() async {
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  Future askPermission() async {
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future getActualLocation() async {
    locationData = await _location.getLocation();
    location = LatLng(locationData.latitude!, locationData.longitude!);
    notifyListeners();
  }
}
