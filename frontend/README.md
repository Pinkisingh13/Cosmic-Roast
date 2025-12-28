# Cosmic Roast - Flutter Frontend

**Live:** https://cosmo-roast.netlify.app

A Flutter app that generates savage roasts based on your birthdate using AI.

---

## Project Structure

```
frontend/lib/
├── main.dart           # Home screen with date input
├── api_service.dart    # API calls to backend
└── result.dart         # Result screen showing roast
```

---

## Files Explained

### `main.dart`
- App entry point and home screen
- Contains date input fields (DD/MM/YYYY)
- Validates birthdate before submitting
- Shows loading spinner during API call
- Clears fields after successful submission

### `api_service.dart`
- Makes POST request to `/roast-me` endpoint
- Base URL: `https://cosmic-roast.onrender.com`
- Returns `null` on error, `Map` on success
- Has `debugPrint` statements for debugging

### `result.dart`
- Shows the roast result
- Displays Mulank number in circle badge
- Back button disabled (only "TRY ANOTHER DATE" works)
- Scrollable for long roasts

---

## API Configuration

Update the base URL in `lib/api_service.dart`:

```dart
static const String baseUrl = 'https://cosmic-roast.onrender.com';
```

---

## Run Locally

```bash
cd frontend
flutter pub get
flutter run -d chrome    # For web
flutter run              # For mobile
```

---

## Build for Web

```bash
flutter build web
```

Output folder: `build/web/`

---

## Deploy to Netlify

1. Build: `flutter build web`
2. Drag `build/web` folder to Netlify
3. Or connect GitHub repo and set:
   - Build command: `flutter build web`
   - Publish directory: `build/web`

---

## Assets

```
frontend/assets/
├── web_bg.png        # Background for web (landscape)
└── vertical_bg.png   # Background for mobile (portrait)
```

---

## Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  http: ^1.6.0
```

Only `http` package is used for API calls.

---

## Key Features

- Responsive: Different backgrounds for web/mobile
- Auto-focus: Moves to next field after 2 digits
- Validation: Checks valid day (1-31), month (1-12), year (1900-now)
- Error handling: Shows snackbar on API failure
- Debug logs: Check console for API request/response details
