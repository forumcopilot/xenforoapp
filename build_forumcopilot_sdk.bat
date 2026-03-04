@echo off
echo Building ForumCopilot SDK...
pushd packages\forumcopilot_sdk
call dart run build_runner build --delete-conflicting-outputs
echo.
echo Analyzing ForumCopilot SDK for errors...
call flutter analyze --no-fatal-infos --no-fatal-warnings
popd
echo ForumCopilot SDK build and analysis completed!
