import 'package:flutter/material.dart';

import '../../../../core/widgets/app_widgets.dart';

class NutritionInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const NutritionInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon = Icons.local_fire_department_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return SummaryCard(title: title, value: value, icon: icon);
  }
}
