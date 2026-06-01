#!/bin/sh -v

# Analyze your Flutter project for potential issues.
flutter analyze

# Check for uncommitted changes in the Git repository and exit with an error code if changes exist.
git diff --exit-code
