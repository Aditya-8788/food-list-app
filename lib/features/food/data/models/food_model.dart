// TODO: Implement food model.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.hotelId,
    required super.ownerId,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.isVeg,
    required super.isAvailable,
  });

  factory FoodModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FoodModel(
      id: doc.id,
      hotelId: data['hotelId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      calories: (data['calories'] ?? 0).toDouble(),
      protein: (data['protein'] ?? 0).toDouble(),
      carbs: (data['carbs'] ?? 0).toDouble(),
      fat: (data['fat'] ?? 0).toDouble(),
      isVeg: data['isVeg'] ?? true,
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  factory FoodModel.fromEntity(FoodEntity food) {
    return FoodModel(
      id: food.id,
      hotelId: food.hotelId,
      ownerId: food.ownerId,
      name: food.name,
      description: food.description,
      price: food.price,
      imageUrl: food.imageUrl,
      category: food.category,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      isVeg: food.isVeg,
      isAvailable: food.isAvailable,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hotelId': hotelId,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'isVeg': isVeg,
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}