import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabaseuupload/firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Automatically handles Web, iOS, and Android
  );

  // Initialize Supabase
  await Supabase.initialize(
      url: 'https://vrficwgiqdstlgvcqasu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyZmljd2dpcWRzdGxndmNxYXN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI1ODUxOTIsImV4cCI6MjA1ODE2MTE5Mn0.Rfp0a0dXnrcfqBOTCgcrfz4uWt3oYKA1ST8mZKdiwqg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase + Firestore Upload',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
