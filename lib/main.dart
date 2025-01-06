// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hcms/screens/house/add_house.dart';
import 'package:hcms/screens/house/house_details.dart';
import 'package:hcms/screens/house/house_list.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'screens/user_view.dart';
import 'screens/auth/register.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVC Example',
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
        ),
        extensions: <ThemeExtension<dynamic>>[
          MoonTheme(tokens: MoonTokens.light)
        ]
      ),
      home: HouseListScreen(),
    );
  }
}
