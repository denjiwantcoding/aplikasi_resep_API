// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasi_resep/main.dart';
import 'package:aplikasi_resep/providers/recipe_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Menampilkan judul beranda', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(),
          child: const RecipeApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Buku Resep Modern'), findsOneWidget);
    });
  });
}
