import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String description;
  final String city;
  final String price;
  final String? image;
  final String ownerUid;
  final DateTime? createdAt;
  final String category;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.price,
    required this.ownerUid,
    this.image,
    this.createdAt,
    required this.category,
  });

  factory Item.fromFirestore(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      city: data['city'] ?? '',
      price: data['price'] ?? '',
      image: data['image'],
      ownerUid: data['ownerUid'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      category: data['category'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'city': city,
      'price': price,
      'image': image,
      'ownerUid': ownerUid,
      'createdAt': createdAt ?? DateTime.now(),
      'category': category
    };
  }
}
