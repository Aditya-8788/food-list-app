// TODO: Define food entity.
import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String id;
  final String hotelId;
  final String ownerId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final bool isVeg;
  final bool isAvailable;

  const FoodEntity({
    required this.id,
    required this.hotelId,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.isVeg,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        hotelId,
        ownerId,
        name,
        description,
        price,
        imageUrl,
        category,
        calories,
        protein,
        carbs,
        fat,
        isVeg,
        isAvailable,
      ];
}