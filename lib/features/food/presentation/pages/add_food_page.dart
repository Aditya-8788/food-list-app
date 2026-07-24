// TODO: Implement add food page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/food_entity.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';

class AddFoodPage extends StatefulWidget {
  final String ownerId;
  final String hotelId;
  final FoodEntity? food;

  const AddFoodPage({
    super.key,
    required this.ownerId,
    required this.hotelId,
    this.food,
  });

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final categoryController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();

  bool isVeg = true;
  bool isAvailable = true;

  bool get isEdit => widget.food != null;

  @override
  void initState() {
    super.initState();

    final food = widget.food;
    if (food != null) {
      nameController.text = food.name;
      descriptionController.text = food.description;
      priceController.text = food.price.toString();
      imageController.text = food.imageUrl;
      categoryController.text = food.category;
      caloriesController.text = food.calories.toString();
      proteinController.text = food.protein.toString();
      carbsController.text = food.carbs.toString();
      fatController.text = food.fat.toString();
      isVeg = food.isVeg;
      isAvailable = food.isAvailable;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    categoryController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }

  double parseDouble(String value) {
    return double.tryParse(value) ?? 0;
  }

  void saveFood() {
    final food = FoodEntity(
      id: widget.food?.id ?? '',
      hotelId: widget.hotelId,
      ownerId: widget.ownerId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: parseDouble(priceController.text),
      imageUrl: imageController.text.trim(),
      category: categoryController.text.trim(),
      calories: parseDouble(caloriesController.text),
      protein: parseDouble(proteinController.text),
      carbs: parseDouble(carbsController.text),
      fat: parseDouble(fatController.text),
      isVeg: isVeg,
      isAvailable: isAvailable,
    );

    if (isEdit) {
      context.read<FoodBloc>().add(UpdateFoodRequested(food));
    } else {
      context.read<FoodBloc>().add(AddFoodRequested(food));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Food' : 'Add Food'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }

          if (state is FoodError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Container(
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
                    _field(nameController, 'Food Name'),
                    _field(descriptionController, 'Description'),
                    _field(priceController, 'Price', number: true),
                    _field(imageController, 'Image URL'),
                    _field(categoryController, 'Category'),
                    _field(caloriesController, 'Calories', number: true),
                    _field(proteinController, 'Protein', number: true),
                    _field(carbsController, 'Carbs', number: true),
                    _field(fatController, 'Fat', number: true),
                    SwitchListTile(
                      title: const Text('Veg Food'),
                      value: isVeg,
                      onChanged: (value) {
                        setState(() => isVeg = value);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Available'),
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() => isAvailable = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    state is FoodLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: saveFood,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                              backgroundColor: const Color(0xffFF6B6B),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(isEdit ? 'Update Food' : 'Add Food'),
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
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}