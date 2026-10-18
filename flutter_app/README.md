# IlmuQuest Flutter MVP

## Setup
1. Install Flutter SDK in your development environment.
2. From this directory run `flutter pub get`.
3. Configure the Supabase URL and anon key using Dart defines:
   `flutter run --dart-define=SUPABASE_URL=YOUR_URL --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY`

Never use the Supabase service_role key in the app.

## Current limitations
This is an early MVP. Confirm the Supabase schema matches the app queries. Server-validated scoring, persistence of answers/XP, admin content management and 3D gameplay are not complete yet.
