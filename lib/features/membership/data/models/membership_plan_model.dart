import '../../domain/entities/membership_plan.dart';

class MembershipPlanModel extends MembershipPlan {
  const MembershipPlanModel({
    required super.id,
    required super.name,
    required super.price,
    required super.duration,
    required super.description,
    required super.features,
  });

  factory MembershipPlanModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return MembershipPlanModel(
      id: documentId,
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      duration: map['duration'] ?? 0,
      description: map['description'] ?? '',
      features: List<String>.from(map['features'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'duration': duration,
      'description': description,
      'features': features,
    };
  }
}