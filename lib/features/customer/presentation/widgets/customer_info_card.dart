import 'package:flutter/material.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerInfoCard extends StatelessWidget {
  final CustomerEntity customer;

  const CustomerInfoCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientHeader(
          label: 'Customer',
          title: customer.name.isEmpty ? 'Your profile' : customer.name,
          trailing: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: customer.profileImage.isNotEmpty
                ? NetworkImage(customer.profileImage)
                : null,
            child: customer.profileImage.isEmpty
                ? const Icon(Icons.person_rounded, color: Colors.white)
                : null,
          ),
          footer: HeaderInfoTile(
            icon: Icons.email_outlined,
            text: customer.email,
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            children: [
              DetailRow(
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: customer.phone.isEmpty
                    ? 'No phone added'
                    : customer.phone,
              ),
              const Divider(height: 26),
              DetailRow(
                icon: Icons.location_on_outlined,
                title: 'Delivery address',
                value: customer.address.isEmpty
                    ? 'No address added'
                    : customer.address,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
