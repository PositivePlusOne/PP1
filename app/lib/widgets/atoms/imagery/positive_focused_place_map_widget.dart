// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';

class PositiveFocusedPlaceMapWidget extends StatefulHookConsumerWidget {
  const PositiveFocusedPlaceMapWidget({
    super.key,
    required this.place,
  });

  final PositivePlace place;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveFocusedPlaceMapWidgetState();
}

class _PositiveFocusedPlaceMapWidgetState extends ConsumerState<PositiveFocusedPlaceMapWidget> {
  GoogleMapController? _controller;
  BitmapDescriptor? _markerIcon;

  @override
  void initState() {
    super.initState();
    setupMarkers();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveFocusedPlaceMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final double? newLat = double.tryParse(oldWidget.place.latitude ?? "");
    final double? newLng = double.tryParse(oldWidget.place.longitude ?? "");
    final bool hasLatLng = newLat != null && newLng != null;
    final bool hasChange = oldWidget.place.latitude != widget.place.latitude || oldWidget.place.longitude != widget.place.longitude;
    if (hasLatLng && hasChange) {
      _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(newLat, newLng)));
    }
  }

  Future<void> setupMarkers() async {
    final asset = await rootBundle.load("assets/images/png/location-point.png");
    final data = asset.buffer.asUint8List();

    _markerIcon = BitmapDescriptor.fromBytes(data);
    setStateIfMounted();
  }

  void onControllerReady(GoogleMapController controller) async {
    final String style = await rootBundle.loadString("assets/maps/style.json");
    await controller.setMapStyle(style);

    _controller = controller;
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double? latitude = double.tryParse(widget.place.latitude ?? "");
    final double? longitude = double.tryParse(widget.place.longitude ?? "");
    final bool hasLocation = latitude != null && longitude != null;

    if (!hasLocation) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
          child: const PositiveLoadingIndicator(),
        ),
      );
    }

    final LatLng latLng = LatLng(latitude, longitude);
    final ValueKey<String> key = ValueKey<String>("map_${widget.place.latitude}_${widget.place.longitude}");

    return AnimatedOpacity(
      opacity: _controller == null ? 0.0 : 1.0,
      duration: kAnimationDurationRegular,
      child: GoogleMap(
        key: key,
        onMapCreated: onControllerReady,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        compassEnabled: false,
        trafficEnabled: false,
        zoomControlsEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        indoorViewEnabled: true,
        markers: <Marker>{
          if (_markerIcon != null) ...<Marker>{
            Marker(
              markerId: const MarkerId("marker_1"),
              position: latLng,
              icon: _markerIcon!,
              draggable: false,
            ),
          },
        },
        circles: <Circle>{
          Circle(
            fillColor: colors.colorGray7.withOpacity(0.1),
            circleId: const CircleId("circle_1"),
            strokeColor: colors.colorGray7.withOpacity(0.0),
            center: latLng,
            radius: kDefaultCircleRadius,
          ),
        },
        initialCameraPosition: CameraPosition(
          target: latLng,
          zoom: kDefaultZoomLevel,
        ),
      ),
    );
  }
}
