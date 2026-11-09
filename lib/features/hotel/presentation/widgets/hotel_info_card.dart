import 'package:flutter/material.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/hotel_entity.dart';

class HotelInfoCard extends StatelessWidget {
  final HotelEntity hotel;

  const HotelInfoCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientHeader(
          label: 'Restaurant',
          title: hotel.hotelName,
          trailing: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: hotel.hotelImage.isNotEmpty
                ? NetworkImage(hotel.hotelImage)
                : null,
            child: hotel.hotelImage.isEmpty
                ? const Icon(Icons.restaurant_rounded, color: Colors.white)
                : null,
          ),
          footer: HeaderInfoTile(
            icon: Icons.person_outline_rounded,
            text: hotel.ownerName,
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            children: [
              DetailRow(
                icon: Icons.email_outlined,
                title: 'Email',
                value: hotel.email,
              ),
              const Divider(height: 26),
              DetailRow(
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: hotel.phone.isEmpty ? 'Not added' : hotel.phone,
              ),
              const Divider(height: 26),
              DetailRow(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: hotel.address.isEmpty ? 'Not added' : hotel.address,
              ),
              const Divider(height: 26),
              DetailRow(
                icon: Icons.schedule_rounded,
                title: 'Status',
                value: hotel.isOpen ? 'Open' : 'Closed',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
