#!/bin/bash
cd packages/forumcopilot_sdk
dart run build_runner build --delete-conflicting-outputs
cd ../..
echo Generating localizations...
flutter gen-l10n
echo Localizations generated successfully!