import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/food_entity.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../widgets/food_card.dart';
import 'food_details_page.dart';

class FoodListPage extends StatefulWidget {
  /// When set, the details page shows an "Order Now" button.
  final String? customerUid;

  const FoodListPage({super.key, this.customerUid});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'All';

  static const _filters = ['All', 'Veg', 'Non-Veg'];

  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(GetAllFoodsRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodEntity> _visible(List<FoodEntity> foods) {
    final q = _query.trim().toLowerCase();
    return foods.where((food) {
      final matchesSearch =
          q.isEmpty ||
          food.name.toLowerCase().contains(q) ||
          food.category.toLowerCase().contains(q);
      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Veg' && food.isVeg) ||
          (_filter == 'Non-Veg' && !food.isVeg);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> _refresh() async {
    final bloc = context.read<FoodBloc>()..add(GetAllFoodsRequested());
    await bloc.stream
        .firstWhere((s) => s is FoodLoaded || s is FoodError)
        .timeout(const Duration(seconds: 10), onTimeout: () => FoodInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: const AppBarTitle(
          title: 'Available Foods',
          subtitle: 'Pick something delicious',
        ),
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading || state is FoodInitial) {
            return const LoadingView(message: 'Loading foods...');
          }

          if (state is FoodError) {
            return MessageView(
              icon: Icons.cloud_off_rounded,
              title: 'Unable to load foods',
              message: state.message,
              buttonText: 'Retry',
              onButtonPressed: () =>
                  context.read<FoodBloc>().add(GetAllFoodsRequested()),
            );
          }

          if (state is! FoodLoaded) return const SizedBox.shrink();

          if (state.foods.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: const MessageView(
                icon: Icons.no_meals_outlined,
                title: 'No foods available',
                message: 'Restaurants have not added any dishes yet.',
              ),
            );
          }

          final foods = _visible(state.foods);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Search food or category',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final f in _filters)
                              FilterChip(
                                label: Text(f),
                                selected: _filter == f,
                                showCheckmark: false,
                                onSelected: (_) => setState(() => _filter = f),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${foods.length} ${foods.length == 1 ? 'dish' : 'dishes'} found',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (foods.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: MessageView(
                      icon: Icons.search_off_rounded,
                      title: 'No matching foods',
                      message: 'Try another name or filter.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                    sliver: SliverList.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return FoodCard(
                          food: food,
                          itemNumber: index + 1,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailsPage(
                                food: food,
                                customerUid: widget.customerUid,
                              ),
                            ),
                          ),
                        );
                      },
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
