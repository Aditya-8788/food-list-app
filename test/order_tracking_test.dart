import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fooddelivery/core/theme/app_theme.dart';
import 'package:fooddelivery/core/utils/helpers.dart';
import 'package:fooddelivery/features/orders/domain/entities/order_entity.dart';
import 'package:fooddelivery/features/orders/presentation/widgets/order_card.dart';
import 'package:fooddelivery/features/orders/presentation/widgets/order_timeline.dart';

OrderEntity _order({
  String status = OrderStatus.preparing,
  List<String> reached = const [
    OrderStatus.placed,
    OrderStatus.confirmed,
    OrderStatus.preparing,
  ],
}) {
  final start = DateTime(2026, 11, 9, 12, 0);
  return OrderEntity(
    id: 'abcdef123',
    customerId: 'c1',
    customerName: 'Asha',
    customerPhone: '9999999999',
    deliveryAddress: 'Pune',
    hotelId: 'h1',
    hotelOwnerId: 'o1',
    hotelName: 'Spice Hub',
    items: const [
      OrderItemEntity(
        foodId: 'f1',
        name: 'Paneer Bowl',
        price: 150,
        quantity: 2,
        isVeg: true,
      ),
    ],
    totalAmount: 300,
    status: status,
    placedAt: start,
    timeline: [
      for (var i = 0; i < reached.length; i++)
        OrderStatusUpdate(
          status: reached[i],
          time: start.add(Duration(minutes: i * 5)),
        ),
    ],
  );
}

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('OrderStatus', () {
    test('next() walks the delivery flow', () {
      expect(OrderStatus.next(OrderStatus.placed), OrderStatus.confirmed);
      expect(
        OrderStatus.next(OrderStatus.outForDelivery),
        OrderStatus.delivered,
      );
      expect(OrderStatus.next(OrderStatus.delivered), isNull);
      expect(OrderStatus.next(OrderStatus.cancelled), isNull);
    });

    test('isActive is false only for finished orders', () {
      expect(OrderStatus.isActive(OrderStatus.preparing), isTrue);
      expect(OrderStatus.isActive(OrderStatus.delivered), isFalse);
      expect(OrderStatus.isActive(OrderStatus.cancelled), isFalse);
    });
  });

  test('OrderEntity derived values', () {
    final order = _order();
    expect(order.itemCount, 2);
    expect(order.shortId, 'ABCDEF');
    expect(order.timeOf(OrderStatus.confirmed), DateTime(2026, 11, 9, 12, 5));
    expect(order.timeOf(OrderStatus.delivered), isNull);
  });

  test('Helpers.currency uses Indian grouping', () {
    expect(Helpers.currency(300), '₹300');
    expect(Helpers.currency(1234567), '₹12,34,567');
  });

  testWidgets('OrderCard shows order number, restaurant and status', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(OrderCard(order: _order(), onTap: () {})));

    expect(find.text('Order #ABCDEF'), findsOneWidget);
    expect(find.text('Spice Hub'), findsOneWidget);
    expect(find.text(OrderStatus.preparing), findsOneWidget);
    expect(find.text('Track order'), findsOneWidget);
  });

  testWidgets('OrderTimeline marks the current step', (tester) async {
    await tester.pumpWidget(_wrap(OrderTimeline(order: _order())));
    await tester.pumpAndSettle();

    for (final status in OrderStatus.flow) {
      expect(find.text(status), findsOneWidget);
    }
    expect(find.text('Current'), findsOneWidget);
  });

  testWidgets('Cancelled order timeline ends with Cancelled', (tester) async {
    final order = _order(
      status: OrderStatus.cancelled,
      reached: const [OrderStatus.placed, OrderStatus.cancelled],
    );
    await tester.pumpWidget(_wrap(OrderTimeline(order: order)));
    await tester.pumpAndSettle();

    expect(find.text(OrderStatus.placed), findsOneWidget);
    expect(find.text(OrderStatus.cancelled), findsOneWidget);
    expect(find.text(OrderStatus.delivered), findsNothing);
  });
}
