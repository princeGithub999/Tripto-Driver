import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripto_driver/utils/app_theme/app_theme.dart';
import 'package:tripto_driver/view/screen/splace_screen.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import 'package:tripto_driver/view_model/provider/permission_handler/permission_provider.dart';
import 'package:tripto_driver/view_model/provider/theme_provider.dart';
import 'package:tripto_driver/view_model/provider/trip_provider/trip_provider.dart';

import 'notification/push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
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
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// import 'package:workmanager/workmanager.dart';


// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     StreamSubscription<Position>? positionStream;
//
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied.');
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permissions are permanently denied.');
//       }
//
//       // ✅ Real-time Location Tracking
//       positionStream = Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 10,
//         ),
//       ).listen((Position position) async {
//         double latitude = position.latitude;
//         double longitude = position.longitude;
//
//         print("Background Location: $latitude, $longitude");
//
//         // ✅ DATABASE UPDATE
//         // await updateLocationInDatabase(latitude, longitude);
//       });
//
//     } catch (e) {
//       print("Location Error: $e");
//     }
//
//     return Future.value(true);
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tripto Driver',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplaceScreen(),
    );
  }
}
