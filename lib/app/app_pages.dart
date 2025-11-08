import 'package:get/get.dart';

import '../presentation/pages/dashboard/dashboard_binding.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/operations/operations_binding.dart';
import '../presentation/pages/operations/operations_page.dart';
import '../presentation/pages/incidents/incidents_binding.dart';
import '../presentation/pages/incidents/incidents_page.dart';
import '../presentation/pages/incident_detail/incident_detail_binding.dart';
import '../presentation/pages/incident_detail/incident_detail_page.dart';
import '../presentation/pages/training/training_binding.dart';
import '../presentation/pages/training/training_page.dart';
import '../presentation/pages/analytics/analytics_binding.dart';
import '../presentation/pages/analytics/analytics_page.dart';
import '../presentation/pages/cameras/cameras_binding.dart';
import '../presentation/pages/cameras/cameras_page.dart';
import '../presentation/pages/settings/settings_binding.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/health/health_binding.dart';
import '../presentation/pages/health/health_page.dart';
import '../presentation/pages/about/about_binding.dart';
import '../presentation/pages/about/about_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const String initial = AppRoutes.dashboard;

  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.operations,
      page: () => const OperationsPage(),
      binding: OperationsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.incidents,
      page: () => const IncidentsPage(),
      binding: IncidentsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.incidentDetails,
      page: () => const IncidentDetailPage(),
      binding: IncidentDetailBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.training,
      page: () => const TrainingPage(),
      binding: TrainingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.analytics,
      page: () => const AnalyticsPage(),
      binding: AnalyticsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.cameras,
      page: () => const CamerasPage(),
      binding: CamerasBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.health,
      page: () => const HealthPage(),
      binding: HealthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
