import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../widgets/food_card.dart';
import 'food_details_page.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(GetAllFoodsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Foods'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FoodLoaded) {
            if (state.foods.isEmpty) {
              return const Center(child: Text('No foods available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.foods.length,
              itemBuilder: (context, index) {
                final food = state.foods[index];

                return FoodCard(
                  food: food,
                  itemNumber: index + 1,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailsPage(food: food),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is FoodError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}