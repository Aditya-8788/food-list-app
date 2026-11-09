import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../../customer/domain/usecases/get_customer_profile_usecase.dart';
import '../../../food/domain/entities/food_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_action_cubit.dart';
import 'order_tracking_page.dart';

/// Pick a quantity, confirm delivery details and place the order.
class CheckoutPage extends StatefulWidget {
  final String customerId;
  final FoodEntity food;

  const CheckoutPage({super.key, required this.customerId, required this.food});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  Future<void> _prefillFromProfile() async {
    try {
      final customer = await sl<GetCustomerProfileUseCase>()(widget.customerId);
      if (!mounted) return;
      setState(() {
        if (_nameController.text.isEmpty) {
          _nameController.text = customer.name;
        }
        if (_phoneController.text.isEmpty) {
          _phoneController.text = customer.phone;
        }
        if (_addressController.text.isEmpty) {
          _addressController.text = customer.address;
        }
      });
    } catch (_) {
      // Profile is optional; the user can type the details manually.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  double get _total => widget.food.price * _quantity;

  void _placeOrder(BuildContext context) {
    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and delivery address'),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final food = widget.food;

    context.read<OrderActionCubit>().placeOrder(
      OrderEntity(
        id: '',
        customerId: widget.customerId,
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        deliveryAddress: _addressController.text.trim(),
        hotelId: food.hotelId,
        hotelOwnerId: food.ownerId,
        hotelName: 'Restaurant',
        items: [
          OrderItemEntity(
            foodId: food.id,
            name: food.name,
            price: food.price,
            quantity: _quantity,
            isVeg: food.isVeg,
          ),
        ],
        totalAmount: _total,
        status: OrderStatus.placed,
        placedAt: now,
        timeline: [OrderStatusUpdate(status: OrderStatus.placed, time: now)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final primary = Theme.of(context).colorScheme.primary;

    return BlocProvider(
      create: (_) => sl<OrderActionCubit>(),
      child: BlocConsumer<OrderActionCubit, OrderActionState>(
        listener: (context, state) {
          if (state is OrderActionSuccess && state.orderId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrderTrackingPage(orderId: state.orderId!),
              ),
            );
          }
          if (state is OrderActionFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final busy = state is OrderActionInProgress;

          return Scaffold(
            appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          Helpers.currency(_total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: busy ? null : () => _placeOrder(context),
                        icon: busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.shopping_bag_rounded),
                        label: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Your Item'),
                  SectionCard(
                    child: Row(
                      children: [
                        const IconBadge(icon: Icons.fastfood_rounded, size: 52),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Helpers.currency(food.price),
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _QuantityStepper(
                          value: _quantity,
                          onChanged: (v) => setState(() => _quantity = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SectionTitle(
                    title: 'Delivery Details',
                    caption: 'Where should we bring your food?',
                  ),
                  SectionCard(
                    child: Column(
                      children: [
                        FormFieldBox(
                          controller: _nameController,
                          label: 'Name',
                          icon: Icons.person_outline_rounded,
                        ),
                        FormFieldBox(
                          controller: _phoneController,
                          label: 'Phone',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        FormFieldBox(
                          controller: _addressController,
                          label: 'Delivery address',
                          icon: Icons.location_on_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SectionTitle(title: 'Bill Summary'),
                  SectionCard(
                    child: Column(
                      children: [
                        _BillRow(
                          label: '${food.name} × $_quantity',
                          value: Helpers.currency(_total),
                        ),
                        const SizedBox(height: 10),
                        const _BillRow(label: 'Delivery fee', value: 'FREE'),
                        const Divider(height: 26),
                        _BillRow(
                          label: 'To pay',
                          value: Helpers.currency(_total),
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove_rounded, color: primary),
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w800)),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value < 20 ? () => onChanged(value + 1) : null,
            icon: Icon(Icons.add_rounded, color: primary),
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _BillRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 16 : 14,
      fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
