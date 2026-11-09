import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
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
        centerTitle: true,
      ),
      body: BlocConsumer<HotelBloc, HotelState>(
        listener: (context, state) {
          if (state is HotelActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          }

          if (state is HotelError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Restaurant Details',
                  caption: 'Customers will see this on their orders.',
                ),
                SectionCard(
                  child: Column(
                    children: [
                      FormFieldBox(
                        controller: hotelNameController,
                        label: 'Hotel Name',
                        icon: Icons.storefront_outlined,
                      ),
                      FormFieldBox(
                        controller: ownerNameController,
                        label: 'Owner Name',
                        icon: Icons.person_outline_rounded,
                      ),
                      FormFieldBox(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      FormFieldBox(
                        controller: phoneController,
                        label: 'Phone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      FormFieldBox(
                        controller: addressController,
                        label: 'Address',
                        icon: Icons.location_on_outlined,
                        maxLines: 3,
                      ),
                      FormFieldBox(
                        controller: imageController,
                        label: 'Hotel Image URL',
                        icon: Icons.image_outlined,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Hotel Open',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text('Accept new orders'),
                        value: isOpen,
                        onChanged: (value) => setState(() => isOpen = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                state is HotelLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: saveHotel,
                        child: Text(
                          isEdit ? 'Update Profile' : 'Create Profile',
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
