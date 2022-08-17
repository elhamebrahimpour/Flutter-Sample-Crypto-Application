import 'package:crypto_v1/provider/provider_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwapIconTheme extends StatelessWidget {
  const SwapIconTheme({Key? key}) : super(key: key);

  get whiteColor => null;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return IconButton(
      onPressed: () {
        themeProvider.swapTheme();
      },
      icon: Icon(Icons.brightness_6),
      color: whiteColor,
    );
  }
}
