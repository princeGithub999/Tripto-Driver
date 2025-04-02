import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripto_driver/utils/app_theme/app_theme.dart';
import 'package:tripto_driver/view/screen/splace_screen.dart';
import 'package:tripto_driver/view/screen/user_get_otp.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';
import 'package:tripto_driver/view_model/provider/history_provider/my_ride_history_provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import 'package:tripto_driver/view_model/provider/permission_handler/permission_provider.dart';
import 'package:tripto_driver/view_model/provider/trip_provider/trip_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      url: 'https://etisnndumecqmopuvome.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0aXNubmR1bWVjcW1vcHV2b21lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0MDg4NDMsImV4cCI6MjA1Njk4NDg0M30.l6gu1jZCRBJHZNBgjgftlR3QIAqlUXoRMJIiMBD-o2I'
  );

  await Firebase.initializeApp();

  FirebaseDatabase database = FirebaseDatabase.instance;
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProviderIn()),
        ChangeNotifierProvider(create: (context) => PermissionProvider()),
        ChangeNotifierProvider(create: (context) => FromProvider()),
        ChangeNotifierProvider(create: (context) => MapsProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        // ChangeNotifierProvider(create: (context) => RideHistoryProvider()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tripto Driver',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplaceScreen(),
    );
  }
}
