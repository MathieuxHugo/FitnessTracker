import 'package:fitnesstracker/model/position_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RunMapPage extends StatelessWidget {
  final List<PositionData> positions;

  RunMapPage({required this.positions});

  @override
  Widget build(BuildContext context) {
    final startMarker = Marker(
      point: LatLng(positions.first.latitude, positions.first.longitude),

      child: const Icon(Icons.flag, color: Colors.green, size: 40),
    );

    final endMarker = Marker(
      point: LatLng(positions.last.latitude, positions.last.longitude),
      child: const Icon(Icons.flag, color: Colors.red, size: 40),
    );

    final markers = [startMarker, endMarker];
    final polylinePoints = positions
        .map((position) => LatLng(position.latitude, position.longitude))
        .toList();

    // Calculate bounds to make sure all markers are visible
    final bounds = LatLngBounds.fromPoints(polylinePoints);

    return FlutterMap(
        options: MapOptions(
          initialZoom: 50,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: polylinePoints,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      );
  }
}
