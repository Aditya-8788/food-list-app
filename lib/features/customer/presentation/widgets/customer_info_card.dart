// TODO: Implement customer info card widget.
import 'package:flutter/material.dart';

import '../../domain/entities/customer_entity.dart';

class CustomerInfoCard extends StatelessWidget {
  final CustomerEntity customer;

  const CustomerInfoCard({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: customer.profileImage.isNotEmpty
                  ? NetworkImage(customer.profileImage)
                  : null,
              child: customer.profileImage.isEmpty
                  ? const Icon(Icons.person, size: 45)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              customer.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(customer.email),
            const SizedBox(height: 8),
            Text(customer.phone.isEmpty ? 'No phone added' : customer.phone),
            const SizedBox(height: 8),
            Text(customer.address.isEmpty ? 'No address added' : customer.address),
          ],
        ),
      ),
    );
  }
}