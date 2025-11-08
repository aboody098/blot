import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app_binding.dart';
import 'app/app_pages.dart';
import 'app/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await GetStorage.init();

  // Initialize environment
  Env.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fire Safety Console',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // RTL support ready
          child: child!,
        );
      },
    );
  }
}
