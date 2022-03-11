import 'package:flutter/material.dart';
import 'package:mutual_project/colors/mutual_colors.dart';
import 'package:mutual_project/providers/login_form_provider.dart';
import 'package:mutual_project/screens/home_screen.dart';
import 'package:mutual_project/screens/login_screen.dart';
import 'package:mutual_project/screens/options_screen.dart';
import 'package:mutual_project/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mutual app',
      initialRoute: 'options',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'register': (_) => const RegisterScreen(),
        'options': (_) => const OptionsScreen(),
      },
    );
  }
}
