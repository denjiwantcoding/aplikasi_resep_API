import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/app_routes.dart';
import 'providers/recipe_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => RecipeProvider()..initialize(),
      child: const RecipeApp(),
    ),
  );
}

class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});

  @override
  State<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Resep Modern',
      theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      routes: AppRoutes.routes,
      home: HomeScreen(
        isDarkMode: isDark,
        onThemeChanged: (value) {
          setState(() => isDark = value);
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
