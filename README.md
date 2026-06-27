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

## Zero-Install Deploy (CI Only)

You don't need Flutter installed locally. The GitHub Action in `.github/workflows/deploy.yml` handles everything:

1. Create a Firebase project named `claritycrew` at https://console.firebase.google.com
2. Create a service account key:
   - Go to https://console.cloud.google.com/apis/credentials
   - Click **Create credentials** → **Service account**, name it `claritycrew-deploy`
   - Assign role **Firebase Admin**, click Done
   - Open the account → **Keys** tab → **Add key** → **Create new key** → **JSON**
   - A file will download — open it and copy the entire contents
3. Add the key to GitHub:
   - Go to repo → **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**, name it `GCP_SERVICE_ACCOUNT_KEY`
   - Paste the entire JSON content, click **Add secret**
4. Push to `master` — the Action will build and deploy automatically

## Local Setup (optional)

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
