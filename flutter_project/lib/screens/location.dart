import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerPopup extends StatefulWidget {
  const LocationPickerPopup({super.key});

  @override
  State<LocationPickerPopup> createState() => LocationPickerPopupState();
}

class LocationPickerPopupState extends State<LocationPickerPopup> {
  LatLng? pickedPoint;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pick Location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPos, latlng) {
                    setState(() => pickedPoint = latlng);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  if (pickedPoint != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: pickedPoint!,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Confirm'),
                onPressed: pickedPoint == null
                    ? null
                    : () => Navigator.pop(context, pickedPoint),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
