import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
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

  double parseDouble(String value) => double.tryParse(value) ?? 0;

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
    const number = TextInputType.numberWithOptions(decimal: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Food' : 'Add Food'),
        centerTitle: true,
      ),
      body: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          }

          if (state is FoodError) {
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
                const SectionTitle(title: 'Basic Info'),
                SectionCard(
                  child: Column(
                    children: [
                      FormFieldBox(
                        controller: nameController,
                        label: 'Food Name',
                        icon: Icons.fastfood_outlined,
                      ),
                      FormFieldBox(
                        controller: descriptionController,
                        label: 'Description',
                        icon: Icons.description_outlined,
                        maxLines: 2,
                      ),
                      FormFieldBox(
                        controller: priceController,
                        label: 'Price (₹)',
                        icon: Icons.currency_rupee_rounded,
                        keyboardType: number,
                      ),
                      FormFieldBox(
                        controller: categoryController,
                        label: 'Category',
                        icon: Icons.category_outlined,
                      ),
                      FormFieldBox(
                        controller: imageController,
                        label: 'Image URL',
                        icon: Icons.image_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const SectionTitle(title: 'Nutrition', caption: 'Per serving.'),
                SectionCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FormFieldBox(
                              controller: caloriesController,
                              label: 'Calories',
                              keyboardType: number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormFieldBox(
                              controller: proteinController,
                              label: 'Protein (g)',
                              keyboardType: number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormFieldBox(
                              controller: carbsController,
                              label: 'Carbs (g)',
                              keyboardType: number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormFieldBox(
                              controller: fatController,
                              label: 'Fat (g)',
                              keyboardType: number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SectionCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Veg Food',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        value: isVeg,
                        onChanged: (value) => setState(() => isVeg = value),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Available',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        value: isAvailable,
                        onChanged: (value) =>
                            setState(() => isAvailable = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                state is FoodLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: saveFood,
                        child: Text(isEdit ? 'Update Food' : 'Add Food'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
