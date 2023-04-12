import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:image/image.dart" as img;

import '../../../dtos/system/design_colors_model.dart';

class ProfileMap extends ConsumerStatefulWidget {
  const ProfileMap({super.key, this.onMapCreated, required this.cameraPosition});

  final Location cameraPosition;
  final void Function(GoogleMapController controller)? onMapCreated;

  @override
  ConsumerState<ProfileMap> createState() => _ProfileMapState();
}

class _ProfileMapState extends ConsumerState<ProfileMap> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant ProfileMap oldWidget) {
    _controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.cameraPosition.lat - 0.05, widget.cameraPosition.lng),
          zoom: 10,
        ),
      ),
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    Set<Circle> circles = {
      Circle(
        fillColor: colors.colorGray7.withOpacity(0.1),
        circleId: const CircleId("circle_1"),
        strokeColor: colors.colorGray7.withOpacity(0.0),
        center: LatLng(widget.cameraPosition.lat, widget.cameraPosition.lng),
        radius: 5000,
      )
    };
    return FutureBuilder(
        future: _getMapMarker(),
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            circles: circles,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.cameraPosition.lat - 0.05, widget.cameraPosition.lng),
              zoom: 10,
            ),
            markers: snapshot.hasData
                ? {
                    Marker(
                      markerId: const MarkerId("marker_1"),
                      position: LatLng(widget.cameraPosition.lat, widget.cameraPosition.lng),
                      icon: snapshot.data as BitmapDescriptor,
                      draggable: false,
                    )
                  }
                : <Marker>{},
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              final style = await rootBundle.loadString("assets/maps/style.json");
              controller.setMapStyle(style);
              _controller = controller;
              widget.onMapCreated?.call(controller);
            },
          );
        });
  }

  Future<BitmapDescriptor> _getMapMarker() async {
    final asset = await rootBundle.load("assets/images/png/location-point.png");
    final data = asset.buffer.asUint8List();
    img.Image? image = img.decodeImage(data);
    img.Image resized = img.copyResize(image!, width: 84, height: 98);
    final resizedData = Uint8List.fromList(img.encodePng(resized));
    return BitmapDescriptor.fromBytes(resizedData);
  }
}
