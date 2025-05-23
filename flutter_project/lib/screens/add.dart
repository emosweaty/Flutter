import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/appbar.dart';
import 'package:flutter_project/screens/home.dart';
import 'package:flutter_project/screens/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AddScreen extends StatefulWidget {
  static const routeName = '/add';
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final titleContrl = TextEditingController();
  final descContrl  = TextEditingController();
  final priceContrl= TextEditingController();

  String? error;
  String billingType = 'Free';
  String? selectedCategory;

  Uint8List? pickedImage;
  GeoPoint? selectedLocation;

  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => pickedImage = bytes);
  }

  Future<void> pickLocationPopup() async {
  final LatLng? chosen = await showDialog<LatLng>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const LocationPickerPopup(),
  );
  if (chosen != null) {
    setState(() => selectedLocation = GeoPoint(chosen.latitude, chosen.longitude));
  }
}

  @override
  void dispose() {
    titleContrl.dispose();
    descContrl.dispose();
    priceContrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final title = titleContrl.text.trim();
    final desc  = descContrl.text.trim();
    final rawPrice = priceContrl.text.trim();
    final setPrice = rawPrice.isEmpty ? 'Free' : rawPrice;

    final user = FirebaseAuth.instance.currentUser!;
    final username = user.displayName ?? 'Unknown';

    if (title.isEmpty || desc.isEmpty) {
      setState(() => error = 'Title & description required');
      return;
    }

    if (selectedCategory == null) {
      setState(() => error = 'Category required');
      return;
    }

    if (selectedLocation == null) {
      setState(() => error = 'Please pick a location.');
      return;
    }

    setState(() {
      isLoading = true;
      error     = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('You must be signed in to post an ad.');
      }

      String? image;
      if (pickedImage != null) {
        image = base64Encode(pickedImage!);
      }

      await FirebaseFirestore.instance.collection('ads').add({
        'title': title,
        'description': desc,
        'price': setPrice,
        'image': image,
        'ownerUid': user.uid,
        'username': username,
        'createdAt': DateTime.now(),
        'category': selectedCategory,
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
      });

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      setState(() => error = 'Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleContrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descContrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: pickLocationPopup,
              icon: const Icon(Icons.map),
              label: const Text('Pick Location'),
            ),

            if (selectedLocation != null) ...[
              const SizedBox(height: 8),
              Text(
                'Lat: ${selectedLocation!.latitude.toStringAsFixed(5)}, '
                'Lon: ${selectedLocation!.longitude.toStringAsFixed(5)}',
              ),
            ],


            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: billingType,
              decoration: const InputDecoration(labelText: 'Billing Type'),
              items: const [
                DropdownMenuItem(value: 'Free', child: Text('Free')),
                DropdownMenuItem(value: 'Paid', child: Text('Paid')),
              ],
              onChanged: (val) {
                setState(() => billingType = val!);
              },
            ),
            if (billingType == 'Paid') ...[

            TextField(
              controller: priceContrl,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed:  false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ],

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'kitchen', child: Text('Kitchen')),
                DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                DropdownMenuItem(value: 'garden', child: Text('Garden')),
                DropdownMenuItem(value: 'electronics', child: Text('Electronics')),
                DropdownMenuItem(value: 'sport', child: Text('Sport')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (val) {
                setState(() => selectedCategory = val!);
              },
            ),
            
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Image'),
            ),

            if (pickedImage != null) ...[
              const SizedBox(height: 12),
              Image.memory(pickedImage!, height: 180, fit: BoxFit.cover),
            ],

            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 24),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: submit,
                    child: const Text('Submit Listing'),
                  ),
          ],
        ),
      ),
    );
  }
}
