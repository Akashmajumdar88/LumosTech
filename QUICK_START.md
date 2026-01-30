# Quick Start Guide

## 🚀 Getting Started

### 1. Navigate to Project Directory
```bash
cd C:\Users\Welcome\.gemini\antigravity\scratch\flutter_hr_assignment
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Check Flutter Setup
```bash
flutter doctor
```

### 4. Run the App
```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## 📱 Testing Offline Mode

1. **First Launch** - Open app with internet connection
2. **Let Data Load** - Wait for posts to load successfully
3. **Close App** - Completely close the application
4. **Turn Off Internet** - Enable airplane mode or disconnect WiFi
5. **Reopen App** - Launch app again
6. **Verify** - You should see cached posts with "Offline" indicator

## 🧪 Manual Testing Steps

### Online Mode Testing
- [x] Launch app with internet
- [x] Verify posts load
- [x] Tap on a post to view details
- [x] Navigate back to list
- [x] Pull down to refresh
- [x] Scroll to bottom and tap "Load More"

### Offline Mode Testing
- [x] Load data with internet
- [x] Turn off internet
- [x] Close and reopen app
- [x] Verify cached data displays
- [x] Check for offline indicator
- [x] Try to load more (should show message)

### Error Handling Testing
- [x] Turn off internet before first launch
- [x] Verify error screen appears
- [x] Turn on internet
- [x] Tap "Try Again" button
- [x] Verify data loads successfully

## 📂 Project Structure

```
flutter_hr_assignment/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/
│   │   └── constants/
│   │       └── api_constants.dart         # API configuration
│   ├── data/
│   │   ├── models/
│   │   │   └── post_model.dart            # Post model
│   │   ├── services/
│   │   │   ├── api_service.dart           # HTTP service
│   │   │   └── cache_service.dart         # Cache service
│   │   └── repositories/
│   │       └── post_repository_impl.dart  # Repository implementation
│   ├── domain/
│   │   └── repositories/
│   │       └── post_repository.dart       # Repository interface
│   └── presentation/
│       ├── screens/
│       │   ├── post_list_screen.dart      # List screen
│       │   └── post_detail_screen.dart    # Detail screen
│       ├── widgets/
│       │   ├── post_card.dart             # Post card widget
│       │   ├── loading_widget.dart        # Loading state
│       │   ├── error_widget.dart          # Error state
│       │   └── empty_widget.dart          # Empty state
│       └── viewmodels/
│           └── post_viewmodel.dart        # State management
├── README.md                              # Comprehensive documentation
├── AI_USAGE.md                            # AI disclosure
└── pubspec.yaml                           # Dependencies
```

## 🎯 Key Features

✅ **REST API Integration** - JSONPlaceholder API
✅ **Offline Support** - SharedPreferences caching
✅ **Pagination** - Load more functionality
✅ **State Management** - Provider pattern
✅ **Clean Architecture** - MVVM with separation of concerns
✅ **Error Handling** - Loading, error, empty states
✅ **Pull to Refresh** - Swipe down to reload

## 📧 Submission Checklist

Before submitting to kiara.dave@lumoslogic.com:

- [ ] Push code to GitHub
- [ ] Verify README.md is complete
- [ ] Verify AI_USAGE.md is included
- [ ] Test app builds and runs
- [ ] Take screenshots (list, detail, offline, error states)
- [ ] Record short demo video (optional but recommended)
- [ ] Send email with GitHub link

## 🔧 Build Commands

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS Build
```bash
flutter build ios --release
```

## 💡 Tips for Technical Interview

Be prepared to explain:

1. **Architecture Choice** - Why MVVM? Why Clean Architecture?
2. **Offline Strategy** - How does caching work? When is cache used?
3. **State Management** - Why Provider? How does it work?
4. **Error Handling** - How are different error states handled?
5. **Data Flow** - Explain the flow from API → Repository → ViewModel → UI
6. **Trade-offs** - What would you improve with more time?

## 📞 Support

If you encounter any issues:
1. Run `flutter doctor` to check setup
2. Run `flutter clean` then `flutter pub get`
3. Restart your IDE
4. Check Flutter version: `flutter --version`

---

**Good luck with your submission! 🚀**
