import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class ProfileMap extends StatefulWidget {
  const ProfileMap({super.key, this.onMapCreated, required this.initialCameraPosition});

  final Location initialCameraPosition;
  final void Function(GoogleMapController controller)? onMapCreated;

  @override
  State<ProfileMap> createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.initialCameraPosition.lat, widget.initialCameraPosition.lng),
        zoom: 14.4746,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("marker_1"),
          position: LatLng(widget.initialCameraPosition.lat, widget.initialCameraPosition.lng),
          draggable: false,
        ),
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        final style = await rootBundle.loadString("assets/maps/style.json");
        controller.setMapStyle(style);
        widget.onMapCreated?.call(controller);
      },
    );
  }
}
