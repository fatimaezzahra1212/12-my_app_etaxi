import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxidriver/clients/client.dart';
import 'package:taxidriver/model/mapss.dart';
import 'package:taxidriver/model/search_places.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        backgroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.clear();

          markers.add(Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude)));

          setState(() {});
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
        backgroundColor: secondaryColor,
      ),
      drawer: Drawer(
        child: Container(
          color: secondaryColor,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("Your Name"),
                  accountEmail: Text("your_email@example.com"),
                  currentAccountPicture: CircleAvatar(
                    child: Text("Y"),
                    backgroundColor: primaryColor,
                  ),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                  )),
              ListTile(
                leading: Icon(Icons.place_outlined),
                title: Text("Endroits enregistrés"),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPlacesScreen()))
                },
              ),
              ListTile(
                leading: Icon(Icons.comment_bank_outlined),
                title: Text("Mes commandes"),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPlacesScreen()))
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About"),
                onTap: () => {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => mapss()))
                },
              ),
              ListTile(
                leading: Icon(Icons.local_offer_outlined),
                title: Text("Promo"),
                onTap: () {
                  // Perform logout action
                },
              ),
              ListTile(
                leading: Icon(Icons.message_outlined),
                title: Text("Services client"),
                onTap: () {
                  // Perform logout action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
