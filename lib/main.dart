import 'package:crypto_v1/provider/provider_theme.dart';
import 'package:crypto_v1/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      child: Application(),
      create: (BuildContext context) {
        return ThemeProvider(isDarkMode: true);
      },
    ),
  );
}

class Application extends StatelessWidget {
  Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
