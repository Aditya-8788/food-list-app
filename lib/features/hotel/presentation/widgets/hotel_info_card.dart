// TODO: Implement hotel info card widget.
import 'package:flutter/material.dart';

import '../../domain/entities/hotel_entity.dart';

class HotelInfoCard extends StatelessWidget {
  final HotelEntity hotel;

  const HotelInfoCard({
    super.key,
    required this.hotel,
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
              backgroundImage:
                  hotel.hotelImage.isNotEmpty ? NetworkImage(hotel.hotelImage) : null,
              child: hotel.hotelImage.isEmpty
                  ? const Icon(Icons.restaurant, size: 45)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              hotel.hotelName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Owner: ${hotel.ownerName}'),
            const SizedBox(height: 8),
            Text(hotel.email),
            const SizedBox(height: 8),
            Text(hotel.phone),
            const SizedBox(height: 8),
            Text(hotel.address),
            const SizedBox(height: 8),
            Chip(
              label: Text(hotel.isOpen ? 'Open' : 'Closed'),
              backgroundColor:
                  hotel.isOpen ? Colors.green.shade100 : Colors.red.shade100,
            ),
          ],
        ),
      ),
    );
  }
}