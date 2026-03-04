@echo off
echo Building all libraries...
call build_forumcopilot_sdk.bat
echo.
echo Running pub get...
dart pub get
echo.
echo Generating localizations...
flutter gen-l10n
echo.
echo All libraries built and analyzed successfully!