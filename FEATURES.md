# Fire Safety Console - Advanced Features

This document details all advanced features implemented in the Flutter Fire Safety Console application.

## 🔔 Push Notifications

### Firebase Cloud Messaging (FCM)
- Real-time push notifications for critical incidents
- Support for different severity levels
- Custom notification handling based on incident type
- Automatic background message handling

### Local Notifications
- Fallback notifications when app is in foreground
- Rich notification UI with custom actions
- Notification categorization by severity
- Persistent notification history

### Setup Instructions
1. Configure Firebase project in Firebase Console
2. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Place files in appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/firebase/GoogleService-Info.plist`
4. Enable Cloud Messaging in Firebase project

### Usage in Code
```dart
final notificationService = Get.find<NotificationService>();

// Show custom notification
await notificationService.showCustomNotification(
  title: 'Incident Alert',
  body: 'New critical incident detected',
  id: 'incident_123',
);

// Listen for notification taps
notificationService.onNotificationTap((payload) {
  // Handle notification tap, navigate to incident
  Get.toNamed(AppRoutes.incidentDetails, arguments: payload);
});
```

## 📡 Offline Sync

### Automatic Offline Detection
- Real-time connectivity monitoring using `connectivity_plus`
- Automatic status updates via `isOnline` observable
- Seamless transition between online/offline modes

### Pending Changes Queue
- Automatic queuing of changes when offline
- Persistent storage of pending operations
- Automatic sync when connection restored
- Manual sync trigger option

### Implementation
```dart
final offlineSync = Get.find<OfflineSync>();

// Queue a change for offline sync
await offlineSync.queueChange(
  'incident_ack_123',
  {'status': 'ACKNOWLEDGED'},
  callback: () async {
    return await _incidentRepo.acknowledgeIncident('123');
  },
);

// Listen to connectivity changes
ever(offlineSync.isOnline, (isOnline) {
  if (isOnline) {
    // Try to sync when connection restored
    offlineSync.syncPendingChanges();
  }
});

// Check pending changes
if (offlineSync.isPending('incident_ack_123')) {
  // Show pending indicator
}
```

## 💾 Local Caching

### Smart Cache System
- Automatic cache expiration with TTL (Time To Live)
- Separate cache entries for different data types
- Cache statistics and monitoring
- Automatic cleanup of expired entries

### Cached Data Types
- **KPI Data** - 5 minute TTL
- **Incidents** - 10 minute TTL
- **Sensors** - 5 minute TTL
- **Cameras** - 1 hour TTL
- **Analytics** - 2 hour TTL
- **Training Runs** - 15 minute TTL

### Usage
```dart
final cache = Get.find<LocalCache>();

// Check for cached data first
if (cache.hasValidCache('kpi')) {
  final cachedKpi = cache.getCachedKpi();
  // Use cached data
} else {
  // Fetch fresh data from API
  final kpi = await _repo.getKpi();
  await cache.cacheKpi(kpi.toJson());
}

// Clear expired cache
await cache.clearExpiredCache();

// View cache statistics
print('Cache size: ${cache.getCacheSize()} entries');
```

## 🔐 State Persistence

### Persistent User Preferences
- App theme preference (light/dark/system)
- Language selection
- Custom user preferences
- API authentication token storage

### Application Statistics
- App open count
- First launch date
- Last route visited
- Last update timestamps

### Settings Management
- YOLO confidence thresholds
- Detection class toggles
- Auto-refresh intervals
- Notification preferences

### Implementation
```dart
final persistence = Get.find<StatePersistence>();

// Save theme preference
await persistence.saveThemeMode('dark');
final theme = persistence.getThemeMode(); // 'dark'

// Save YOLO settings
await persistence.saveYoloThreshold(0.75);
final threshold = persistence.getYoloThreshold(); // 0.75

// Export/Import settings
final settingsMap = persistence.exportSettings();
await persistence.importSettings(settingsMap);

// Track app statistics
final openCount = persistence.getAppOpenCount();
final firstLaunch = persistence.getFirstLaunchDate();
```

## 🔥 Firebase Integration

### Authentication
- Email/Password authentication
- Persistent authentication state
- Secure token management
- User session management

### Firestore Database
- Real-time incident data sync
- Cloud-based incident storage
- Document query capabilities
- Real-time listeners for updates

### Firebase Storage
- Evidence upload (images/videos)
- Secure file management
- Automatic cleanup
- Download URL generation

### Usage
```dart
final firebase = Get.find<FirebaseService>();

// Authentication
try {
  await firebase.signUpWithEmail('user@example.com', 'password123');
  await firebase.signInWithEmail('user@example.com', 'password123');
} catch (e) {
  // Handle auth error
}

// Firestore operations
await firebase.addDocument('incidents', {
  'title': 'Fire Detected',
  'severity': 'CRITICAL',
  'timestamp': DateTime.now(),
});

// Stream real-time updates
firebase.streamCollection('incidents').listen((incidents) {
  // Handle real-time updates
});

// Storage operations
final url = await firebase.uploadFile(
  '/path/to/evidence.jpg',
  'incident_123_evidence.jpg',
);
```

## 🧪 Testing

### Unit Tests
- Model serialization/deserialization
- Repository functionality
- Service operations
- Data transformation logic

### Widget Tests
- Widget rendering
- User interactions
- Theme support
- Layout validation

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/incident_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report
lcov --list coverage/lcov.info
```

### Test Structure
```
test/
├── models/              # Model unit tests
│   ├── incident_test.dart
│   └── camera_test.dart
├── services/            # Service unit tests
│   └── local_cache_test.dart
└── widgets/             # Widget tests
    ├── kpi_card_test.dart
    └── alert_list_item_test.dart
```

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow
Automated testing, building, and deployment:

1. **Test Job**
   - Run unit/widget tests
   - Analyze code with `flutter analyze`
   - Check formatting
   - Upload coverage to Codecov

2. **Build Jobs** (Parallel)
   - Android APK build
   - Web build
   - Windows desktop build

3. **Release Job** (On tag push)
   - Create GitHub release
   - Upload APK and builds
   - Generate release notes

### Trigger Events
- Push to `claude/**` branches (feature)
- Push to `main` and `develop` branches
- Pull requests to `main` and `develop`
- Version tag pushes (triggers release)

### Workflow File
Located at `.github/workflows/ci_cd.yml`

### Running Locally
```bash
# Simulate GitHub Actions locally
# Install act: https://github.com/nektos/act
act -j test
act -j build_android
```

## 📦 Asset Management

### Directory Structure
```
assets/
├── images/              # App images (logos, backgrounds)
├── icons/               # Custom SVG icons
├── fonts/               # Custom font files
└── data/                # JSON data files
```

### Using Assets in Code
```dart
// Images
Image.asset('assets/images/logo.png')

// Icons
Icon(Icons.custom_icon)

// Custom fonts
TextStyle(fontFamily: 'Roboto')
```

## 🔐 Security Best Practices

1. **API Security**
   - HTTPS only for API calls
   - API token in secure storage
   - Request/response encryption (where needed)

2. **Local Storage**
   - Encrypted GetStorage
   - No sensitive data in plain text
   - Secure token management

3. **Firebase Security**
   - Firestore security rules
   - Storage bucket rules
   - Authentication best practices

4. **Code Security**
   - No hardcoded secrets
   - Environment variables for sensitive data
   - Regular dependency updates

## 🎯 Performance Optimization

1. **Caching Strategy**
   - Multi-level caching (memory + disk)
   - Smart TTL management
   - Automatic cache cleanup

2. **Offline Support**
   - Reduced API calls
   - Faster data access
   - Seamless experience

3. **Network Optimization**
   - Connection monitoring
   - Request batching
   - Efficient data sync

## 📊 Monitoring & Analytics

### App Statistics
- App open count
- User session duration
- Feature usage tracking
- Error rate monitoring

### System Metrics
- Cache statistics
- Offline sync status
- Network connectivity state
- Storage usage

### Future Enhancements
- User analytics integration
- Crash reporting
- Performance monitoring
- Event tracking

---

For more information, see [README.md](README.md) and individual feature documentation.
