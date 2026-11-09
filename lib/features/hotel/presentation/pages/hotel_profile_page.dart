import 'package:flutter/material.dart';

import '../../domain/entities/hotel_entity.dart';
import '../widgets/hotel_info_card.dart';
import 'edit_hotel_profile_page.dart';

class HotelProfilePage extends StatelessWidget {
  final HotelEntity hotel;

  const HotelProfilePage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        child: Column(
          children: [
            HotelInfoCard(hotel: hotel),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditHotelProfilePage(
                      hotel: hotel,
                      ownerId: hotel.ownerId,
                      ownerEmail: hotel.email,
                      ownerName: hotel.ownerName,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Hotel Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
