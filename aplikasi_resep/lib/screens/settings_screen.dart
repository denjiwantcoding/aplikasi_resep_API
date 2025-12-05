import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool>? onThemeChanged;

  const SettingsScreen({
    super.key,
    this.isDarkMode = false,
    this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    darkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() => darkMode = widget.isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          value: darkMode,
          onChanged: (val) {
            setState(() => darkMode = val);
            widget.onThemeChanged?.call(val);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(val ? 'Dark Mode Aktif' : 'Light Mode Aktif'),
              ),
            );
          },
        ),
        const ListTile(title: Text('Versi Aplikasi'), subtitle: Text('1.0.0')),
      ],
    );
  }
}
