# SwypeUp Flutter App

A mobile application for discovering and joining spontaneous local activities. Built with Flutter and Riverpod for state management.

## Features

### ✅ Implemented Features
- **User Authentication**: Register and login with email/password
- **Activity Discovery**: Swipe-based interface to browse nearby activities
- **Activity Management**: View activities you're hosting and participating in
- **Real-time Chat**: Group chat for activity participants using Stream Chat
- **Real-time Updates**: Automatic refresh of activity feeds
- **Beautiful UI**: Modern Material Design 3 with custom gradients and animations
- **State Management**: Riverpod for efficient state management
- **API Integration**: Full integration with NestJS backend

### 🚧 Planned Features
- **Location Services**: Get user's current location for better activity discovery
- **Push Notifications**: Notify users about new activities and chat messages
- **Activity Creation**: Create new activities with location and time selection
- **Profile Management**: Update user profile and preferences

## Screenshots

### Authentication Screen
- Clean login/register interface with form validation
- Toggle between login and register modes
- Error handling and loading states

### Discover Screen
- Swipeable activity cards with beautiful gradients
- Activity information including host, location, time, and participant count
- Swipe right to join, left to skip
- Visual feedback for swipe actions

### My Activities Screen
- Tabbed interface for hosting and participating activities
- Activity cards with status indicators
- Pull-to-refresh functionality
- Empty states with helpful messages
- Chat button to open group chat for each activity

### Chat Screen
- Real-time group chat for activity participants
- Stream Chat integration with modern UI
- Activity information display
- Message history and real-time updates

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Swipeable Cards**: appinio_swiper
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts (Inter)
- **Date/Time**: intl package
- **Real-time Chat**: Stream Chat Flutter SDK

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   └── activity.dart
├── services/                 # API services
│   ├── api_service.dart
│   └── chat_service.dart
├── providers/                # Riverpod providers
│   ├── auth_provider.dart
│   ├── activities_provider.dart
│   └── chat_provider.dart
├── screens/                  # App screens
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── discover_screen.dart
│   ├── my_activities_screen.dart
│   └── chat_screen.dart
├── widgets/                  # Reusable widgets
│   ├── activity_card.dart
│   └── activity_list_item.dart
└── utils/                    # Utility functions
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd swypeup_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure backend URL**
   Update the `baseUrl` in `lib/services/api_service.dart` to point to your NestJS backend:
   ```dart
   static const String baseUrl = 'http://your-backend-url:3000';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable web support** (optional)
   ```bash
   flutter config --enable-web
   ```

2. **Run on web**
   ```bash
   flutter run -d chrome
   ```

3. **Build for production**
   ```bash
   flutter build apk --release
   flutter build ios --release
   ```

## API Integration

The app integrates with the SwypeUp NestJS backend API. Make sure your backend is running and accessible before testing the app.

### Required Backend Endpoints
- `POST /auth/register` - User registration
- `POST /auth/login` - User authentication
- `GET /users/me` - Get user profile
- `PUT /users/me` - Update user profile
- `GET /activities/feed` - Get nearby activities
- `POST /activities` - Create new activity
- `POST /activities/:id/join` - Join activity
- `GET /activities/me` - Get user's activities

## State Management

The app uses Riverpod for state management with the following providers:

### AuthProvider
- Manages user authentication state
- Handles login/logout operations
- Stores JWT tokens securely
- Provides user profile information

### ActivitiesProvider
- Manages activity data and feeds
- Handles activity loading and joining
- Provides hosting and participating activities
- Manages loading and error states

### ChatProvider
- Manages Stream Chat client and connections
- Handles chat channel joining and leaving
- Provides real-time messaging capabilities
- Manages chat state and error handling

## UI/UX Features

### Design System
- **Color Scheme**: Material Design 3 with custom primary color
- **Typography**: Inter font family for modern readability
- **Spacing**: Consistent 8px grid system
- **Shadows**: Subtle elevation for depth

### Animations
- **Swipe Animations**: Smooth card transitions
- **Loading States**: Skeleton screens and spinners
- **Micro-interactions**: Button presses and hover effects

### Accessibility
- **Semantic Labels**: Proper accessibility labels
- **Color Contrast**: WCAG compliant color combinations
- **Touch Targets**: Minimum 44px touch targets
- **Screen Reader Support**: Proper widget semantics

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## Deployment

### Android
1. Update `android/app/build.gradle` with your app details
2. Generate a signed APK:
   ```bash
   flutter build apk --release
   ```

### iOS
1. Update `ios/Runner/Info.plist` with your app details
2. Build for iOS:
   ```bash
   flutter build ios --release
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue on GitHub or contact the development team.
