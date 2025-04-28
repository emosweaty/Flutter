import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../appbar.dart';
import '../item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';
  
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = _fetchItems();
  }

  Future<List<Item>> _fetchItems() async {
    final snap = await FirebaseFirestore.instance
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((doc) => Item.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: const Color.fromARGB(255, 246, 245, 255),
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(62, 0, 0, 0),
                    blurRadius: 2,
                    offset: Offset(-.5, 1)
                  )
                ]
              ),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Text('Filter'),

                  SizedBox(height: 12),
                  
                ],
              ),
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Appliances',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: FutureBuilder<List<Item>>(
                      future: items,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child:
                                  Text('Error: ${snapshot.error}'));
                        }
                        final items = snapshot.data!;
                        if (items.isEmpty) {
                          return const Center(
                              child: Text('No items available'));
                        }

                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: () {
                                      final String? b64 = item.image;
                                      if (b64 != null && b64.isNotEmpty) {
                                        final Uint8List bytes = base64Decode(b64);
                                        return Image.memory(
                                          bytes,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: const Center(child: Icon(Icons.image, size: 48)),
                                      );
                                    }(),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                                ),
                                              ),
                                              Text('5 KM',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                ),
                                              )
                                            ],
                                          ),

                                          SizedBox(height: 5),

                                          Text( item.description,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}