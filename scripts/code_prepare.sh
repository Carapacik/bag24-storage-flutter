#!/bin/sh

# Clean Flutter cache
flutter clean

# Fetch Flutter package dependencies.
flutter pub get

# (Optional) Run build_runner to generate code, but it's currently commented out.
dart run build_runner build -d

# Format Dart code with specific settings.
dart format --set-exit-if-changed --line-length=120 lib/

# Exit with success status (0).
exit 0
