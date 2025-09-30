# Daily Victory

A productivity app to help users focus on one task at a time, manage daily habits and goals, and stay motivated.

## Features

- Task Management
  - Create, update, and delete tasks
  - Set priorities and due dates
  - Track task completion
  - Add attachments and notes

- Habit Tracking
  - Create and manage daily habits
  - Track streaks and progress
  - Set reminders and notifications
  - View habit statistics

- User Authentication
  - Email/password authentication
  - Secure user profiles
  - Data synchronization

- Theme Support
  - Light and dark mode
  - Customizable appearance
  - Responsive design

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.3)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/dailyvictory.git
cd dailyvictory
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Business logic
├── utils/          # Utilities and helpers
└── widgets/        # Reusable widgets
```

## Dependencies

- flutter_riverpod: State management
- firebase_core: Firebase integration
- firebase_auth: Authentication
- cloud_firestore: Database
- firebase_storage: File storage
- firebase_analytics: Analytics
- intl: Internationalization
- shared_preferences: Local storage
- flutter_svg: SVG support
- google_fonts: Custom fonts
- flutter_animate: Animations
- lottie: Lottie animations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- All contributors who have helped shape this project

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)
Project Link: [https://github.com/yourusername/dailyvictory](https://github.com/yourusername/dailyvictory)
