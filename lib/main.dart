import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/firebase_options.dart';
import 'package:tripto_driver/utils/app_theme/app_theme.dart';
import 'package:tripto_driver/view/screen/splace_screen.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/map_provider.dart';
import 'package:tripto_driver/view_model/provider/permission_handler/permission_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseDatabase database = FirebaseDatabase.instance;
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PermissionProvider()),
        ChangeNotifierProvider(create: (context) => AuthProviderIn()),
        ChangeNotifierProvider(create: (context) => FromProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
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
      home: SplaceScreen(),
    );
  }
}
