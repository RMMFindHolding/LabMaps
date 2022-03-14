import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mutual_project/providers/location_provider.dart';
import 'package:provider/provider.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  String address = "";
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    // GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar ciudad'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 600,
            child: Column(
              children: [
                const Text('Por favor, ingresar calle, altura, provincia y/o ciudad a buscar', textAlign: TextAlign.center),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.black.withOpacity(0.1),
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (value) => address = value,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    )
                  ),
                ),
                if(isError)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text('Error, por favor dar mas detalles de la dirección', style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                    onPressed: () async {
                      final argumento = await calcularLatLng(address);
                      if(argumento != null) {
                        _controller.clear();
                        // await initLocation(context);
                        Navigator.pushNamed(context, 'home',
                          arguments: argumento);
                      } else {
                        setState(() {
                          isError = true;
                        });
                        Future.delayed(const Duration(seconds: 4), (){
                          setState(() => isError = false);  
                        });
                      }
                    },
                    child: const Text('Localizar')),
              ],
            )),
      ),
    );
  }
}

Future<LatLng?> calcularLatLng(String ciudad) async {
  double? lat;
  double? lng;

  try {
    List<Location> locations = await locationFromAddress(ciudad);
    lat = locations[0].latitude;
    lng = locations[0].longitude;

    return LatLng(lat, lng);
  } catch (e) {
    return null;
  }
  
}

Future<void> initLocation(context) async {
  final locationProvider =
      Provider.of<LocationProvider>(context, listen: false);

  // await locationProvider.enableService();
  // await locationProvider.askPermission();
  await locationProvider.getActualLocation();

  return;
}
