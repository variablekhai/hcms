// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hcms/screens/auth/login.dart';
import 'package:hcms/screens/house/add_house.dart';
import 'package:hcms/screens/house/house_details.dart';
import 'package:hcms/screens/house/house_list.dart';
import 'package:hcms/firebase_options.dart';
import 'package:hcms/screens/booking/add_booking.dart';
import 'package:hcms/screens/booking/booking_details.dart';
import 'package:hcms/screens/booking/booking_list.dart';
import 'package:hcms/screens/booking/edit_booking.dart';

import 'package:hcms/screens/cleaner/cleaner_jobs.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';
import 'package:moon_design/moon_design.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'screens/user_view.dart';
import 'screens/auth/register.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
  const MyApp({super.key});

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
      home: LoginView(),
    );
  }
}
