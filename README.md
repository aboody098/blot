# Fire Safety Console - Flutter Application

A complete **Flutter** application using **GetX** state management and **MVMS (Model → View → ViewModel → Service)** architecture for an **Industrial Fire / Smoke / Gas Leak / PPE Detection System**.

## 📋 Overview

The Fire Safety Console is a real-time monitoring and control application designed for oil & gas facilities. It provides comprehensive incident tracking, live sensor monitoring, YOLO model training management, and system health analytics.

### Key Features

- **Live Dashboard** - Real-time KPIs, alert feeds, sensor data, and service status
- **Operations Console** - Multi-camera grid with live metrics
- **Incident Management** - Filterable list with detailed incident tracking and actions
- **Model Training** - Start, monitor, and promote YOLO training runs
- **Analytics** - Charts for alert trends, PPE compliance, and camera uptime
- **Camera Management** - Add/Edit/Delete camera configurations
- **System Settings** - YOLO thresholds, class toggles, and integration settings
- **Health Monitoring** - GPU/CPU usage, storage, uptime, and system logs
- **Dark Mode Support** - Full theme support with light/dark modes
- **RTL Ready** - Prepared for Arabic and RTL language support
- **Firebase Integration** - Auth, Firestore, and Storage support
- **Push Notifications** - Firebase Cloud Messaging + Local Notifications
- **Offline Support** - Automatic sync when connection restored
- **Local Caching** - Smart cache with TTL management
- **State Persistence** - User preferences and app settings saved locally
- **Comprehensive Testing** - Unit and widget tests included
- **CI/CD Pipeline** - GitHub Actions for automated testing and builds

## 🏗️ Project Architecture

### MVMS Pattern

```
UI Layer (Views)
    ↓
ViewModels (Controllers)
    ↓
Services (API Client + WebSocket)
    ↓
Data Layer (Repositories + Models)
```

### Directory Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app_binding.dart              # Global dependency injection
│   ├── app_pages.dart                # Route configuration
│   ├── app_routes.dart               # Route constants
│   └── theme/
│       ├── app_theme.dart            # Theme definitions
│       ├── colors.dart               # Color palette
│       └── text_styles.dart          # Typography
├── core/
│   ├── env.dart                      # Environment configuration
│   ├── logger.dart                   # Logging utility
│   ├── constants.dart                # App constants
│   └── mock_data.dart                # Mock data for offline mode
├── data/
│   ├── models/                       # Data classes
│   │   ├── incident.dart
│   │   ├── camera.dart
│   │   ├── sensor.dart
│   │   ├── kpi_snapshot.dart
│   │   ├── training_run.dart
│   │   ├── detection_class.dart
│   │   └── service_status.dart
│   ├── services/
│   │   ├── api_client.dart           # REST API client (Dio)
│   │   └── websocket_service.dart    # WebSocket with auto-reconnect
│   └── repositories/
│       ├── incident_repository.dart
│       ├── camera_repository.dart
│       ├── sensor_repository.dart
│       ├── analytics_repository.dart
│       └── training_repository.dart
└── presentation/
    ├── widgets/                      # Reusable components
    │   ├── kpi_card.dart
    │   ├── alert_list_item.dart
    │   ├── sensor_gauge.dart
    │   └── camera_tile.dart
    └── pages/                        # 10 feature pages
        ├── dashboard/
        ├── operations/
        ├── incidents/
        ├── incident_detail/
        ├── training/
        ├── analytics/
        ├── cameras/
        ├── settings/
        ├── health/
        └── about/
```

## 🚀 Getting Started

### Prerequisites

- Flutter 3.0+ (stable)
- Dart 3.0+

### Installation

```bash
# Clone the repository
git clone <repo>

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running with Mock Data

The app includes comprehensive mock data and works without a backend server. All pages are populated with realistic sample data.

## 📦 Dependencies

Key libraries used:

```yaml
get: ^4.6.6                           # State management & navigation
dio: ^5.7.0                           # REST API client
web_socket_channel: ^2.4.0            # WebSocket support
get_storage: ^2.1.1                   # Local persistence
fl_chart: ^0.66.2                     # Charts & graphs
json_annotation: ^4.9.0               # JSON serialization
equatable: ^2.0.5                     # Equality comparison
intl: ^0.19.0                         # Internationalization
timeago: ^3.5.0                       # Time formatting
shimmer: ^3.0.0                       # Loading animations
```

## 🎨 UI/UX Features

### Color System

- **Critical**: `#D13438` (Red) - High priority incidents
- **Major**: `#FFB900` (Yellow) - Medium priority
- **Minor**: `#3B78FF` (Blue) - Low priority
- **Primary**: `#0043CE` (Blue) - Brand color
- **Success**: `#07A41E` (Green) - Healthy status
- **Error**: `#D13438` (Red) - Error/offline

### Typography

- Display, Headline, Title, Body, and Label styles
- Responsive font sizing
- RTL-ready text rendering

### Components

- **KPI Cards** - Metric displays with icons
- **Alert List Items** - Incident notifications with severity badges
- **Sensor Gauges** - Circular progress indicators
- **Camera Tiles** - Camera management items

## 🔌 API Integration

### REST Endpoints

```
GET  /api/kpi                         # KPI snapshot
GET  /api/incidents                   # Incident list
GET  /api/incidents/{id}              # Single incident
POST /api/incidents/{id}/ack          # Acknowledge
POST /api/incidents/{id}/escalate     # Escalate
POST /api/incidents/{id}/close        # Close
GET  /api/cameras                     # Camera list
POST /api/cameras                     # Add camera
PUT  /api/cameras/{id}                # Edit camera
DELETE /api/cameras/{id}              # Delete camera
GET  /api/sensors                     # Sensor data
GET  /api/service/health              # System health
POST /api/training/start              # Start training
GET  /api/training                    # Training runs
POST /api/training/{id}/promote       # Promote model
GET  /api/analytics                   # Analytics data
```

### WebSocket Messages

The app handles real-time updates via WebSocket:

```json
{
  "type": "IncidentCreated",
  "payload": { /* incident data */ }
}

{
  "type": "IncidentUpdated",
  "payload": { /* incident data */ }
}

{
  "type": "SensorTick",
  "payload": { /* sensor data */ }
}

{
  "type": "ServiceHealthTick",
  "payload": { /* health data */ }
}

{
  "type": "TrainingProgress",
  "payload": { /* training data */ }
}
```

## 🎯 Pages Overview

### 1. Dashboard
Real-time overview with KPIs, recent incidents, sensor readings, and service health.

### 2. Operations
Multi-camera grid view with live metrics and fullscreen capability.

### 3. Incidents
Advanced incident list with filtering, search, and statistics.

### 4. Incident Detail
Detailed incident view with evidence gallery, timeline, and actions.

### 5. Training
YOLO model training management with progress tracking and metrics.

### 6. Analytics
Historical data visualization with charts and trends analysis.

### 7. Cameras
Camera inventory management with add/edit/delete functionality.

### 8. Settings
Application and detection configuration with YOLO thresholds.

### 9. Health
System resource monitoring and performance analytics.

### 10. About
Application information and external links.

## 🔐 State Management

The app uses **GetX** for all state management:

- `GetxController` for page controllers
- `.obs` reactive variables
- `Obx()` widgets for reactive UI
- `Bindings` for dependency injection
- Named routes with `GetMaterialApp`

## 🌐 Internationalization (i18n)

The app is prepared for multi-language support:

- `Directionality` widget for RTL support
- `intl` package for date/time formatting
- Ready for Arabic translation

## 🧪 Testing & Mock Data

Mock data is provided in `lib/core/mock_data.dart`:

- 5 sample incidents with various severity levels
- 4 cameras with different statuses
- 5 sensors with realistic readings
- 3 training runs in different states
- Complete service health and analytics data

## ✨ Advanced Features

### 🔔 Push Notifications
- Real-time Firebase Cloud Messaging (FCM)
- Local notification fallback
- Severity-based notification styling
- Automatic notification handling

### 📡 Offline Sync
- Automatic connectivity detection
- Pending changes queue
- Smart auto-sync when online
- Manual sync trigger

### 💾 Local Caching
- Multi-level caching system
- TTL-based cache expiration
- Data type-specific caching
- Automatic cleanup

### 🔐 State Persistence
- User preferences storage
- App settings persistence
- API token secure storage
- App usage statistics tracking

### 🔥 Firebase Integration
- Email/Password authentication
- Firestore real-time database
- Firebase Storage for media
- Secure token management

### 🧪 Testing Suite
- Unit tests for models and services
- Widget tests for UI components
- Test coverage reporting
- CI/CD integration

## 🚀 Setup Guide

### Firebase Setup

#### 1. Create Firebase Project
- Go to [Firebase Console](https://console.firebase.google.com)
- Create new project: `fire-safety-console`
- Enable these services:
  - Authentication (Email/Password)
  - Cloud Firestore
  - Firebase Storage
  - Cloud Messaging

#### 2. Android Setup
```bash
# Download google-services.json from Firebase Console
# Place in: android/app/google-services.json

# Update android/build.gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
  }
}

# Update android/app/build.gradle
plugins {
  id 'com.google.gms.google-services'
}
```

#### 3. iOS Setup
```bash
# Download GoogleService-Info.plist from Firebase Console
# Place in: ios/firebase/GoogleService-Info.plist

# In Xcode:
# 1. Add file to Runner project
# 2. Enable capabilities: Push Notifications
# 3. Add APNs certificate in Firebase Console
```

#### 4. Web Setup
```bash
# In Firebase Console, register web app
# Get config values
# Update lib/core/env.dart with Firebase config

# Run app
flutter run -d chrome
```

### Environment Configuration

Update `lib/core/env.dart`:
```dart
class Env {
  static void init() {
    _isDevelopment = true;
    _apiBaseUrl = 'https://api.example.com';
    _wsBaseUrl = 'wss://api.example.com';
    // Firebase config
    _firebaseProjectId = 'fire-safety-console';
  }
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
lcov --list coverage/lcov.info

# Run specific test file
flutter test test/models/incident_test.dart

# Run tests on specific platform
flutter test -d chrome  # Web
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release
```

## 🛠️ Development

### Adding a New Page

1. Create page directory: `lib/presentation/pages/[page_name]/`
2. Create three files:
   - `[page_name]_controller.dart`
   - `[page_name]_binding.dart`
   - `[page_name]_page.dart`
3. Add route to `app/app_routes.dart`
4. Add page to `app/app_pages.dart`

### Using Repositories

```dart
final repo = Get.find<IncidentRepository>();
final incidents = await repo.getIncidents();
```

### WebSocket Integration

```dart
final wsService = Get.find<WebSocketService>();
wsService.on('IncidentCreated', (payload) {
  // Handle incident creation
});
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows (Desktop)
- ✅ macOS

## 🎨 Theme Customization

Modify colors in `lib/app/theme/colors.dart` and themes in `lib/app/theme/app_theme.dart`.

## 🔄 CI/CD

The project is ready for:

- Flutter analysis with `flutter analyze`
- Unit/Widget testing
- Integration testing
- Automated deployment

## 📝 License

This project is part of the Fire Safety Console system.

## 👥 Contributing

Follow Flutter and Dart best practices:

- Use consistent naming conventions
- Follow MVMS architecture
- Add appropriate error handling
- Use mock data for testing
- Test on multiple devices

## 📞 Support

For issues and questions, refer to the project documentation or contact the development team.

---

**Version**: 1.0.0
**Last Updated**: 2024-11-08
**Status**: Production Ready
