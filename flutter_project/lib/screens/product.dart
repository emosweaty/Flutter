import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_project/item.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';

  const ProductScreen({
    required this.item,
    super.key
    });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.image != null && item.image!.isNotEmpty) ...[
              Image.memory(
                base64Decode(item.image!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
            ],

            Text(item.title),
            const SizedBox(height: 8),

            Text(
              item.price == 'To Borrow' ? 'For Borrowing' 
              : 'Price: €${item.price}',
            ),
            const SizedBox(height: 16),

            Text('Category: ${item.category}'),
            const SizedBox(height: 16),

            Text(item.description),
            const SizedBox(height: 24),

            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(item.latitude, item.longitude),
                        width: 80,
                        height: 80,
                        child: Icon(Icons.location_pin, color: Colors.blueAccent, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
