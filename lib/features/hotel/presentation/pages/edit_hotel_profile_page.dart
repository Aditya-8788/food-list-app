// TODO: Implement edit hotel profile page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hotel_entity.dart';
import '../bloc/hotel_bloc.dart';
import '../bloc/hotel_event.dart';
import '../bloc/hotel_state.dart';

class EditHotelProfilePage extends StatefulWidget {
  final HotelEntity? hotel;
  final String ownerId;
  final String ownerEmail;
  final String ownerName;

  const EditHotelProfilePage({
    super.key,
    this.hotel,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerName,
  });

  @override
  State<EditHotelProfilePage> createState() => _EditHotelProfilePageState();
}

class _EditHotelProfilePageState extends State<EditHotelProfilePage> {
  final hotelNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final imageController = TextEditingController();

  bool isOpen = true;

  bool get isEdit => widget.hotel != null;

  @override
  void initState() {
    super.initState();

    final hotel = widget.hotel;

    if (hotel != null) {
      hotelNameController.text = hotel.hotelName;
      ownerNameController.text = hotel.ownerName;
      emailController.text = hotel.email;
      phoneController.text = hotel.phone;
      addressController.text = hotel.address;
      imageController.text = hotel.hotelImage;
      isOpen = hotel.isOpen;
    } else {
      ownerNameController.text = widget.ownerName;
      emailController.text = widget.ownerEmail;
    }
  }

  @override
  void dispose() {
    hotelNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void saveHotel() {
    final hotel = HotelEntity(
      hotelId: widget.hotel?.hotelId ?? '',
      ownerId: widget.ownerId,
      hotelName: hotelNameController.text.trim(),
      ownerName: ownerNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      hotelImage: imageController.text.trim(),
      isOpen: isOpen,
      rating: widget.hotel?.rating ?? 0,
    );

    if (isEdit) {
      context.read<HotelBloc>().add(UpdateHotelProfileRequested(hotel));
    } else {
      context.read<HotelBloc>().add(CreateHotelProfileRequested(hotel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Hotel Profile' : 'Create Hotel Profile'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<HotelBloc, HotelState>(
        listener: (context, state) {
          if (state is HotelActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }

          if (state is HotelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Container(
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _field(hotelNameController, 'Hotel Name'),
                    _field(ownerNameController, 'Owner Name'),
                    _field(emailController, 'Email'),
                    _field(phoneController, 'Phone'),
                    _field(addressController, 'Address', maxLines: 3),
                    _field(imageController, 'Hotel Image URL'),
                    SwitchListTile(
                      title: const Text('Hotel Open'),
                      value: isOpen,
                      onChanged: (value) {
                        setState(() {
                          isOpen = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    state is HotelLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: saveHotel,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                              backgroundColor: const Color(0xffFF6B6B),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              isEdit ? 'Update Profile' : 'Create Profile',
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}