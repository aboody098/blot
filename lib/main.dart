import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app_binding.dart';
import 'app/app_pages.dart';
import 'app/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/env.dart';
import 'core/logger.dart';
import 'data/local/local_cache.dart';
import 'data/local/state_persistence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize local storage
    await GetStorage.init();
    Logger.info('GetStorage initialized', tag: 'main');

    // Initialize local cache
    final cache = LocalCache();
    await cache.initialize();
    Logger.info('LocalCache initialized', tag: 'main');

    // Initialize state persistence
    final persistence = StatePersistence();
    await persistence.initialize();
    Logger.info('StatePersistence initialized', tag: 'main');

    // Initialize environment
    Env.init();
    Logger.info('Environment initialized', tag: 'main');

    // Track app open
    await persistence.incrementAppOpenCount();
    await persistence.setFirstLaunchDate();

    runApp(const MyApp());
  } catch (e) {
    Logger.error('Failed to initialize app', tag: 'main', exception: e);
    runApp(const ErrorWidget());
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to initialize app'),
              const SizedBox(height: 8),
              Text(
                'Please check logs for details',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
