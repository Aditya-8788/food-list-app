// TODO: Implement hotel profile page.
import 'package:flutter/material.dart';

import '../../domain/entities/hotel_entity.dart';
import '../widgets/hotel_info_card.dart';
import 'edit_hotel_profile_page.dart';

class HotelProfilePage extends StatelessWidget {
  final HotelEntity hotel;

  const HotelProfilePage({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Profile'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFF6B6B),
              Color(0xffFF8E53),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            HotelInfoCard(hotel: hotel),
            const SizedBox(height: 24),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xffFF6B6B),
              ),
              child: const Text('Edit Hotel Profile'),
            ),
          ],
        ),
      ),
    );
  }
}