// TODO: Implement food remote data source.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_model.dart';

abstract class FoodRemoteDataSource {
  Future<void> addFood(FoodModel food);

  Future<void> updateFood(FoodModel food);

  Future<void> deleteFood(String foodId);

  Future<List<FoodModel>> getAllFoods();

  Future<List<FoodModel>> getHotelFoods(String ownerId);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final FirebaseFirestore firestore;

  FoodRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<void> addFood(FoodModel food) async {
    final docRef = firestore.collection('foods').doc();

    await docRef.set({
      ...food.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateFood(FoodModel food) async {
    await firestore.collection('foods').doc(food.id).update(
          food.toFirestore(),
        );
  }

  @override
  Future<void> deleteFood(String foodId) async {
    await firestore.collection('foods').doc(foodId).delete();
  }

  @override
  Future<List<FoodModel>> getAllFoods() async {
    final snapshot = await firestore
        .collection('foods')
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => FoodModel.fromFirestore(doc)).toList();
  }

  @override
  Future<List<FoodModel>> getHotelFoods(String ownerId) async {
    final snapshot = await firestore
        .collection('foods')
        .where('ownerId', isEqualTo: ownerId)
        .get();

    return snapshot.docs.map((doc) => FoodModel.fromFirestore(doc)).toList();
  }
}