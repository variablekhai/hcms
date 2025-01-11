// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hcms/screens/auth/login.dart';
import 'package:hcms/firebase_options.dart';
import 'package:moon_design/moon_design.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  Stripe.publishableKey = 'pk_test_51QBuXtEbdf93ZSBchgoENGapIfl7UuEQhMmOPiAmZ3ILH86kcQu8PpCgBiiFS5cQpYQTM2tzfvBdD70xcEhiX61Y00H3XZLoWb';
  await dotenv.load(fileName: "assets/.env");
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'hcms',
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
          textTheme: GoogleFonts.poppinsTextTheme(),
          extensions: <ThemeExtension<dynamic>>[
            MoonTheme(tokens: MoonTokens.light)
          ]),
      home: LoginView(),
    );
  }
}
