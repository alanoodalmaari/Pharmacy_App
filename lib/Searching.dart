import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:pharmacy_app/Patient/Guardian.dart';
import 'package:pharmacy_app/constant/map_key.dart';
import 'package:pharmacy_app/screens/patient_home.dart';


class SearchingScreen extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchingScreen> {
  final allowedPharmacyList = ["Guardian","Watson","Health Lane Family","CARiNG","Big","AA"];

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: MapKey.apiKey);
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Map<String, Marker> _markers = {};
  bool isLoading = true;
  String errorMessage = '';

  void _onMapCreated(GoogleMapController controller) async {
    try {
      final center = await getUserLocation();
      //final center = LatLng(3.0704353, 101.7072921);

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: center == null ? LatLng(0, 0) : center, zoom: 13.0)));

      final pharmacies =
      await getNearbyPharmacies(center); //find nearby pharmacies here

      setState(() {
        _markers.clear();
        for (final result in pharmacies) {
          final pharmacyName = shouldAdd(result);
          if(pharmacyName != null) {
            PlacesSearchResult pharmacy = PlacesSearchResult(reference: result.reference, name: pharmacyName,
                placeId: result.id, geometry: result.geometry, formattedAddress: result.formattedAddress);

            final marker = Marker(
                markerId: MarkerId(pharmacyName),
                position: LatLng(pharmacy.geometry.location.lat,
                    pharmacy.geometry.location.lng),
                infoWindow: InfoWindow(
                  title: pharmacyName,
                  snippet: pharmacy.formattedAddress,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PatientPharmacyHomePage(
                            pharmacy: pharmacy,
                          ),
                    ),
                  );
                });
            _markers[pharmacyName] = marker;
          }
        }
      });
    } catch (e) {
      onError(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<PlacesSearchResult>> getNearbyPharmacies(LatLng center) async {
    final location = Location(lat: center.latitude, lng: center.longitude);
    final result =
    await _places.searchNearbyWithRadius(location, 2500, type: 'pharmacy');
    print(result.results.length);
    return result.results;
  }

  void onError(e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Something went wrong")));
    print('something went wrong' + e.toString());
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PatientHomePage (),));

          },
        ),
        title: Text('Nearby pharmacies'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: _markers.values.toSet(),
          ),
          if (isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }

  String shouldAdd(PlacesSearchResult pharmacy) {
    for(String name in allowedPharmacyList){
      if(pharmacy.name.toLowerCase().contains(name.toLowerCase())){
        return name;
      }
    }
    return null;
  }
}
