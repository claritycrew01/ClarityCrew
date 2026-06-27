# ClarityCrew

A calm, accessible learning platform for neurodivergent students. Built with Flutter Web, Firebase, and Kolibri content integration.

## Tech Stack

- **Flutter Web** — cross-platform web UI
- **Firebase Hosting** — deployment
- **Cloud Firestore** — structured data storage
- **Kolibri** — content source model

## Architecture

```
lib/
├── main.dart              # App entry point
├── app.dart               # Router & theme config
├── models/                # Firestore data models
├── services/              # Firebase, Auth, Content, AI services
├── providers/             # State management (ChangeNotifier)
├── screens/               # Full-page screens
├── widgets/               # Reusable UI components
└── utils/                 # Constants, theme, colors, typography
```

## Data Model

- **Course** → **Subject** → **Unit** → **Lesson**
- Each lesson has: overview, notes, resources (videos/docs), quizzes, exercises
- **UserProgress**, **RecentActivity**, **Recommendation** track personalization
- **ContentSource** for Kolibri ingestion with source IDs and versioning

## Setup

1. Install Flutter SDK (stable channel, >=3.1.0)
2. Clone this repo
3. Run `flutter pub get`
4. Create a Firebase project and enable Auth + Firestore
5. Update `lib/services/firebase_service.dart` with your Firebase config
6. Generate `lib/firebase_options.dart` via `flutterfire configure`
7. Run `flutter run -d chrome` for local dev
8. Build for production: `flutter build web`
9. Deploy: `firebase deploy`

## Key Features

- Personalized dashboard with progress tracking
- Course categories (CBSE, ICSE, competitive exams, skill learning)
- Modular lesson system (notes, videos, quizzes, exercises, revision, AI help)
- AI learning companion (ClarityBuddy) with chat, explanations, summaries
- Full accessibility controls (text size, contrast, reduced motion, focus mode)
- Kolibri content ingestion-ready structure
- No hardcoded content — fully database-driven

## Accessibility

- Text size scaling (80%–180%)
- Contrast adjustment
- Reduced motion mode
- Focus mode
- Clean, readable typography
- Keyboard-friendly navigation
- Calm, low-distraction UI

## License

MIT
