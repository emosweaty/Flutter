import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String description;
  final String price;
  final String? image;
  final String ownerUid;
  final String username;
  final DateTime? createdAt;
  final String category;
  final double latitude;
  final double longitude;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.ownerUid,
    required this.username,
    this.image,
    this.createdAt,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  factory Item.fromFirestore(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      image: data['image'],
      ownerUid: data['ownerUid'] ?? '',
      username: data['username'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      category: data['category'] ?? '',
      latitude:     (data['latitude']    as num?)?.toDouble() ?? 0.0,
      longitude:    (data['longitude']   as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'ownerUid': ownerUid,
      'username': username,
      'createdAt': createdAt ?? DateTime.now(),
      'category': category,
      'latitude'    : latitude,
      'longitude'   : longitude,
    };
  }
}
