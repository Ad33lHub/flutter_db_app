/// The main entry point for the Student Info application.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

/// The entry point of the application.
void main() {
  runApp(const StudentInfoApp());
}

/// The root widget of the Student Info application.
///
/// This widget is a [StatefulWidget] that manages the theme of the application.
class StudentInfoApp extends StatefulWidget {
  /// Creates a new instance of [StudentInfoApp].
  const StudentInfoApp({super.key});

  @override
  State<StudentInfoApp> createState() => _StudentInfoAppState();
}

/// The state for [StudentInfoApp].
class _StudentInfoAppState extends State<StudentInfoApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  /// Loads the theme preference from [SharedPreferences].
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDark') ?? false;
    });
  }

  /// Toggles the theme between light and dark mode.
  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveThemePreference(_isDarkMode);
  }

  /// Saves the theme preference to [SharedPreferences].
  void _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Info Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeToggle: toggleTheme),
    );
  }
}
