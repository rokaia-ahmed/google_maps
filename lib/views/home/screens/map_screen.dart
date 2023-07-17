
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/core/helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  FloatingSearchBarController controller= FloatingSearchBarController();
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
  Widget buildFloatingSearchBar(){
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: controller,
      hint: 'find a place...',
      elevation: 6,
      hintStyle:const TextStyle(fontSize: 18) ,
      queryStyle:const TextStyle(fontSize: 18),
      border: const BorderSide(
        style: BorderStyle.none,
      ),
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor:Colors.blue ,
      scrollPadding: const EdgeInsets.only(top: 16,bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait?0.0:- 1,
      openAxisAlignment: 0.0,
      width: isPortrait?600:500,
      debounceDelay:const Duration(milliseconds: 500) ,
      onQueryChanged: (query){},
      onFocusChanged:(_){} ,
      transition:CircularFloatingSearchBarTransition() ,
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon:Icon(Icons.place,
            color:Colors.black.withOpacity(0.6) ,
            ) ,
            onPressed:(){} ,
          ),
        ),
      ],
      builder:(context, transition) {
        return ClipRRect(
          borderRadius:BorderRadius.circular(0.8),
          child:const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [],
          ) ,
        );
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
        fit: StackFit.expand,
        children: [
        position !=null? buildMap():
            const Center(
              child: CircularProgressIndicator(
                color:Colors.blue ,
              ),
            ),
        buildFloatingSearchBar(),
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
