import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'strings.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MapWidget());
  }

}

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final CameraPosition _kInitialPosition;
  final CameraTargetBounds _cameraTargetBounds;
  static double defaultZoom = 12.0;
  final Location _location = Location();
  CameraPosition _position;
  late MapboxMapController mapController;
  bool _isMoving = false;
  final bool _compassEnabled = true;
  final MinMaxZoomPreference _minMaxZoomPreference =
  const MinMaxZoomPreference(0, 14.0);
  final String _styleString = "mapbox://styles/mapbox/outdoors-v11";
  final bool _rotateGesturesEnabled = true;
  final bool _scrollGesturesEnabled = true;
  final bool _tiltGesturesEnabled = false;
  final bool _zoomGesturesEnabled = true;
  final bool _myLocationEnabled = false;
  var _tilesLoaded = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;


  MapWidgetState._ (
      this._kInitialPosition, this._position, this._cameraTargetBounds);


  static CameraPosition _getCameraPosition() {
    const latLng = LatLng(38.863, -106.988);
    return CameraPosition(
      target: latLng,
      zoom: defaultZoom,
    );
  }

  factory MapWidgetState() {
    CameraPosition cameraPosition = _getCameraPosition();


    final cityBounds = LatLngBounds(
      southwest: const LatLng(38.759, -107.164),
      northeast: const LatLng(39.187, -106.806),
    );


    return MapWidgetState._(
        cameraPosition, cameraPosition, CameraTargetBounds(cityBounds));
  }

  void _onMapChanged() {
    _location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
    setState(() {
      _extractMapInfo();
    });
  }

  @override
  initState() {
    super.initState();
    setOffline(true, accessToken: Strings.mapboxPublicKey);
    _copyTilesIntoPlace();
  }
  _copyTilesIntoPlace() async {
    try {
      await installOfflineMapTiles(join("assets", "cache.db"));
    } catch (err) {
      print(err);
    }
    setState(() {
      _tilesLoaded = true;
    });
  }


  @override
  void dispose() {
    if (mapController != null) {
      mapController.removeListener(_onMapChanged);
    }
    super.dispose();
  }


  void _extractMapInfo() {
    _position = mapController.cameraPosition!;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildMapBox(context),
    );
  }
  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.onSymbolTapped.add(onSymbolTap);
    _extractMapInfo();
    setState(() {});
  }
  void _handleLongTap(Point<double> point, LatLng coordinates) {
      mapController.addSymbol(
        SymbolOptions(
          geometry: coordinates,
          iconImage: 'Marker'),
          {'count':1},
      );
  }
  void onSymbolTap(Symbol symbol) {
    mapController.removeSymbol(symbol);
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }


  void _onStyleLoaded() {
    addImageFromAsset('Marker', 'images/avalanche.png');

}

  MapboxMap _buildMapBox(BuildContext context) {
    return MapboxMap(
        onMapCreated: onMapCreated,
        onMapLongClick: _handleLongTap,
        onStyleLoadedCallback: _onStyleLoaded,
        initialCameraPosition: _kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: _compassEnabled,
        cameraTargetBounds: _cameraTargetBounds,
        minMaxZoomPreference: _minMaxZoomPreference,
        styleString: _styleString,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        myLocationEnabled: _myLocationEnabled,
        myLocationTrackingMode: _myLocationTrackingMode,
        accessToken: Strings.mapboxPublicKey,
        onCameraTrackingDismissed: () {
          setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });
  }
}