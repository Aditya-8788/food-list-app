import 'package:equatable/equatable.dart';

class MembershipPlan extends Equatable {
  final String id;
  final String name;
  final int price;
  final int duration;
  final String description;
  final List<String> features;

  const MembershipPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.features,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        duration,
        description,
        features,
      ];
}