# DentiPlus mobile app

Flutter app for **DentiPlus**, a dental consultation platform. Patients describe their symptoms in a chat, get an AI-assisted preliminary diagnosis and book appointments, and dentists review, validate or follow up on consultations. Diagnoses are anchored on a blockchain so their integrity can be verified.

The API is in [`backend/`](../backend/) (FastAPI). Screenshots are in the [main README](../README.md).

## Features

**Patients**
- Sign up with email verification, log in, reset and change password
- Chat-based consultation that produces an AI-assisted diagnosis
- Book, reschedule and cancel appointments
- Check that a consultation's diagnosis has not been altered (blockchain integrity check)
- Profile and settings

**Dentists**
- List consultations, filtered by state
- Consultation details with the patient's chat and the diagnosis
- Validate a consultation or request a follow-up consultation

## Tech stack

- Flutter 3.29.2, Dart
- Provider for state management
- Dio for the API, JWT authentication (`jwt_decoder`, `shared_preferences`)
- `flutter_chat_ui` for the chat, `image_picker`, `google_fonts`

## Project structure

```
lib/
├── Screens/     Login and sign-up, patient and dentist spaces
├── Widgets/     Reusable UI components
├── providers/   State: auth, consultations, chat, appointments, blockchain
├── modals/      Data models
└── services/    API client and endpoint configuration (config.dart)
```

## Getting started

### Requirements

- Flutter 3.29.2 (see `version.txt`)
- The DentiPlus API running (see the [backend README](../backend/README.md); it listens on port 5001)

### Configuration

The backend URL is set in `lib/services/config.dart`:

```dart
static const String baseUrl = 'http://127.0.0.1:5001';
```

On the Android emulator, use `http://10.0.2.2:5001` to reach a backend running on your computer. On a phone, use your computer's local IP address.

### Run

```bash
flutter pub get
flutter run
```
