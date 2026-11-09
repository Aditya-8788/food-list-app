import 'package:flutter_test/flutter_test.dart';

import 'package:fooddelivery/features/food/presentation/widgets/food_image.dart';

void main() {
  test('FoodImage.hasImage accepts only http(s) URLs with a host', () {
    expect(FoodImage.hasImage('https://example.com/burger.jpg'), isTrue);
    expect(FoodImage.hasImage(' http://cdn.site/p.png '), isTrue);
    expect(FoodImage.hasImage(''), isFalse);
    expect(FoodImage.hasImage('burger.jpg'), isFalse);
    expect(FoodImage.hasImage('ftp://example.com/a.jpg'), isFalse);
    expect(FoodImage.hasImage('https://'), isFalse);
  });
}
