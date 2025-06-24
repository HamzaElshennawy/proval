import 'package:flutter/material.dart';
import 'package:proval/pages/home_page.dart';
import 'package:proval/providers/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:proval/providers/match_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (context) => ApiProvider()),
      ],
      
      child: const MyApp(),
    ),
  );
}

// base url https://vlrggapi.vercel.app/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(),
    );
  }
}
