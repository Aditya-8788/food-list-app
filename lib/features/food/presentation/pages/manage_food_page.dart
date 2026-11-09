import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../widgets/food_card.dart';
import 'add_food_page.dart';

class ManageFoodPage extends StatefulWidget {
  final String ownerId;
  final String hotelId;

  const ManageFoodPage({
    super.key,
    required this.ownerId,
    required this.hotelId,
  });

  @override
  State<ManageFoodPage> createState() => _ManageFoodPageState();
}

class _ManageFoodPageState extends State<ManageFoodPage> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(GetHotelFoodsRequested(widget.ownerId));
  }

  void refreshFoods() {
    context.read<FoodBloc>().add(GetHotelFoodsRequested(widget.ownerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: const AppBarTitle(
          title: 'Manage Food',
          subtitle: 'Swipe left on a dish to delete it',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddFoodPage(ownerId: widget.ownerId, hotelId: widget.hotelId),
            ),
          );
          refreshFoods();
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            refreshFoods();
          }
        },
        builder: (context, state) {
          if (state is FoodLoading) {
            return const LoadingView(message: 'Loading menu...');
          }

          if (state is FoodLoaded) {
            if (state.foods.isEmpty) {
              return const MessageView(
                icon: Icons.no_meals_outlined,
                title: 'No food added yet',
                message: 'Tap + to add your first dish.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
              itemCount: state.foods.length,
              itemBuilder: (context, index) {
                final food = state.foods[index];

                return Dismissible(
                  key: ValueKey(food.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Food'),
                            content: const Text(
                              'Are you sure you want to delete this food?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) {
                    context.read<FoodBloc>().add(DeleteFoodRequested(food.id));
                  },
                  child: FoodCard(
                    food: food,
                    itemNumber: index + 1,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddFoodPage(
                            ownerId: widget.ownerId,
                            hotelId: widget.hotelId,
                            food: food,
                          ),
                        ),
                      );
                      refreshFoods();
                    },
                  ),
                );
              },
            );
          }

          if (state is FoodError) {
            return MessageView(
              icon: Icons.cloud_off_rounded,
              title: 'Unable to load menu',
              message: state.message,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
