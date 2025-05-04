import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/appbar.dart';
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
      appBar: Appbar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                clipBehavior: Clip.hardEdge,  
                child: item.image != null && item.image!.isNotEmpty
                  ? Image.memory(
                      base64Decode(item.image!),
                        width: double.infinity,
                       height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
                ),
              )
            ),

            SizedBox(width: 16),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontFamily: 'Dongle',
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 45,
                                height: .8
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Text(
                            item.price == 'To Borrow' ? 'For Borrowing' : '€ ${item.price}',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 116, 220, 238),
                            ),
                          ),
                        ],
                      ),

                      Text(item.category,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 155, 155, 160)
                        ),
                      ),
                      
                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('"${item.description}"',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic
                          ),
                        )
                      ),

                      SizedBox(height: 10),

                      Text(item.username),
                      
                      SizedBox(height: 10),

                      SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(item.latitude, item.longitude),
                            initialZoom: 13.0
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
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}