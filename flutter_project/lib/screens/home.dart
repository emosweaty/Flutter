import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/screens/product.dart';

import '../appbar.dart';
import '../item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';
  
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  String? selectedCity;
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = fetchItems();
  }

   void loadItems() {
    items = fetchItems(
      category: selectedCategory,
      city:     selectedCity,
    );
    setState(() {});
  }

  Future<List<Item>> fetchItems({String? category, String? city}) async {
    var ref = FirebaseFirestore.instance
        .collection('ads')
        .orderBy('createdAt', descending: true);

    if (category != null) ref = ref.where('category', isEqualTo: category);
    if (city     != null) ref = ref.where('city',     isEqualTo: city);

    final snap = await ref.get();
    return snap.docs.map((d) => Item.fromFirestore(d.id, d.data())).toList();

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
                  const Text('Filter by Category'),
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('All'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: 'kitchen', child: Text('Kitchen')),
                        DropdownMenuItem(value: 'garden', child: Text('Garden')),
                        DropdownMenuItem(value: 'electronics', child: Text('Electronics')),
                        DropdownMenuItem(value: 'sport', child: Text('Sport')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        setState(() => selectedCategory = val);
                        loadItems();
                      },
                    ),

                    const SizedBox(height: 20),
                    const Text('Filter by City'),
                    DropdownButton<String>(
                      value: selectedCity,
                      hint: const Text('All'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: "dessel", child: Text('dessel')),
                        DropdownMenuItem(value: 'Antwerp', child: Text('Antwerp')),
                      ],
                      onChanged: (val) {
                        setState(() => selectedCity = val);
                        loadItems();
                      },
                    ),
                  
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
                        builder: (ctx, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snap.hasError) {
                            return Center(
                              child: Text(
                                'Error loading items:\n${snap.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          final items = snap.data ?? [];
                          if (items.isEmpty) {
                            return const Center(child: Text('No items match your filters.'));
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
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductScreen.routeName,
                                    arguments: item,
                                  );
                                },
                                child: Card(
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