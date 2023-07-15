import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/core/helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {

  static Position? position;

  final Completer<GoogleMapController> _mapController=Completer<GoogleMapController>();
  static final CameraPosition _myCurrentLocationCameraPosition=CameraPosition(
      target: LatLng(position!.latitude,position!.longitude),
      bearing: 0.0,
      tilt: 0.0,
      zoom: 17,
  );
  Future<void> getMyCurrentLocation()async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }
  Widget buildMap(){
    return GoogleMap(
       mapType: MapType.normal,
      myLocationEnabled:true ,
      zoomControlsEnabled: false,
      myLocationButtonEnabled:false ,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated:(GoogleMapController controller){
        _mapController.complete(controller);
      } ,
    );
  }
  Future<void> _goToMyCurrentLocation()async{
   final GoogleMapController controller =
   await _mapController.future;
   controller.animateCamera(
       CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        position !=null? buildMap():
            const Center(
              child: CircularProgressIndicator(
                color:Colors.blue ,
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        margin:const EdgeInsets.fromLTRB(0, 0, 8, 30) ,
        child: FloatingActionButton(
          onPressed:_goToMyCurrentLocation ,
          backgroundColor:Colors.blue ,
          child:const Icon(Icons.place,
           color:Colors.white ,
          ) ,
        ),
      ),
    );
  }
}
