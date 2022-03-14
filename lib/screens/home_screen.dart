import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  late LocationData _currentPosition;

  Future<Uint8List> getBytesFromAsset({required String path,required int width})async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(), 
      targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png))!
    .buffer.asUint8List();
  }

  LatLng? actualLocation;

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng address = ModalRoute.of(context)!.settings.arguments as LatLng;

    // Marcadores
    Set<Marker> markers = <Marker>{};
    markers.add(Marker(
      markerId: const MarkerId('my-location'),
      position: address,
      infoWindow: const InfoWindow(title: 'Lugar seleccionado'),
    ));

    markers.add(const Marker(
      markerId:  MarkerId('Clinica Santa Isabel'),
      position: LatLng(-34.63083915706623, -58.455539977035755),
      infoWindow: InfoWindow(title: 'Clínica Santa Isabel', snippet: 'Lautaro 369, C1406DKG C1406DKG, Buenos Aires'),
    ));

    markers.add(const Marker(
      markerId:  MarkerId('Hospital Italiano segurola 3860'),
      position: LatLng(-34.62776695111983, -58.45523956970974),
      infoWindow: InfoWindow(title: 'Hospital Italiano', snippet: 'Av. Carabobo 148, C1406 DGO, Buenos Aires'),
    ));

    markers.add(const Marker(
      markerId:  MarkerId('Hospital General de Agudos - Dr Alvarez'),
      position: LatLng(-34.6229995097702, -58.46965912420264),
      infoWindow: InfoWindow(title: 'Hospital General de Agudos - Dr Alvarez', snippet: 'Dr. Juan Felipe Aranguren 2701, C1406 CABA'),
    ));

    markers.add( const Marker(
      markerId: MarkerId('Hospital de Rehabilitación Manuel Rocca'),
      position: LatLng(-34.61727821859502, -58.50137356101888),
      infoWindow: InfoWindow(title: 'Hospital de Rehabilitación Manuel Rocca', snippet: 'Av. Segurola 1949, C1407 AOM, Buenos Aires'),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: actualLocation == null ? address : actualLocation!,
                    zoom: 16
                  )
                )
              );
            }, 
            icon: const Icon(Icons.location_on)
          )
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        markers: markers,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: address, zoom: 16),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    actualLocation = LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
  }


}
