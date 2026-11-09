import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../../customer/domain/usecases/get_customer_profile_usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/order_action_cubit.dart';
import '../widgets/cart_widgets.dart';
import 'order_tracking_page.dart';

/// Cart review + delivery details + place order.
class CheckoutPage extends StatefulWidget {
  final String customerId;

  const CheckoutPage({super.key, required this.customerId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

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

  void _placeOrder(BuildContext context, CartState cart) {
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

    context.read<OrderActionCubit>().placeOrder(
      OrderEntity(
        id: '',
        customerId: widget.customerId,
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        deliveryAddress: _addressController.text.trim(),
        hotelId: cart.hotelId ?? '',
        hotelOwnerId: cart.hotelOwnerId ?? '',
        hotelName: 'Restaurant',
        items: cart.items.map((item) => item.toOrderItem()).toList(),
        totalAmount: cart.total,
        status: OrderStatus.placed,
        placedAt: now,
        timeline: [OrderStatusUpdate(status: OrderStatus.placed, time: now)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderActionCubit>(),
      child: BlocConsumer<OrderActionCubit, OrderActionState>(
        listener: (context, state) {
          if (state is OrderActionSuccess && state.orderId != null) {
            context.read<CartCubit>().clear();
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
        builder: (context, orderState) {
          final busy = orderState is OrderActionInProgress;
          final cart = context.watch<CartCubit>().state;

          return Scaffold(
            appBar: AppBar(title: const Text('Your Cart'), centerTitle: true),
            bottomNavigationBar: cart.isEmpty
                ? null
                : _PlaceOrderBar(
                    total: cart.total,
                    busy: busy,
                    onPressed: () => _placeOrder(context, cart),
                  ),
            body: cart.isEmpty
                ? MessageView(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Your cart is empty',
                    message: 'Add some dishes and they will show up here.',
                    buttonText: 'Browse foods',
                    buttonIcon: Icons.restaurant_menu_rounded,
                    onButtonPressed: () => Navigator.pop(context),
                  )
                : _CartBody(
                    cart: cart,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                  ),
          );
        },
      ),
    );
  }
}

class _CartBody extends StatelessWidget {
  final CartState cart;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const _CartBody({
    required this.cart,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Items',
            caption:
                '${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'} in your cart.',
          ),
          SectionCard(
            child: Column(
              children: [
                for (var i = 0; i < cart.items.length; i++) ...[
                  if (i > 0) const Divider(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: cart.items[i].food.isVeg
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.items[i].food.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              Helpers.currency(cart.items[i].total),
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      QuantityStepper(
                        value: cart.items[i].quantity,
                        onDecrement: () => cubit.remove(cart.items[i].food),
                        onIncrement:
                            cart.items[i].quantity < CartCubit.maxQuantity
                            ? () => cubit.add(cart.items[i].food)
                            : null,
                      ),
                    ],
                  ),
                ],
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
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.person_outline_rounded,
                ),
                FormFieldBox(
                  controller: phoneController,
                  label: 'Phone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                FormFieldBox(
                  controller: addressController,
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
                  label: 'Item total',
                  value: Helpers.currency(cart.total),
                ),
                const SizedBox(height: 10),
                const _BillRow(label: 'Delivery fee', value: 'FREE'),
                const Divider(height: 26),
                _BillRow(
                  label: 'To pay',
                  value: Helpers.currency(cart.total),
                  bold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final bool busy;
  final VoidCallback onPressed;

  const _PlaceOrderBar({
    required this.total,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                Text('Total', style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  Helpers.currency(total),
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
                onPressed: busy ? null : onPressed,
                icon: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_bag_rounded),
                label: const Text('Place Order'),
              ),
            ),
          ],
        ),
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
