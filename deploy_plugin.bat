@echo off
if "%DEST_BASE%"=="" set DEST_BASE=Z:\path\to\your\xf2
echo ForumCopilot XenForo Plugin Deployment Script - copies files to server directory %DEST_BASE%\src
echo Source: plugins\FC_XenForo2\upload\src\addons\ForumCopilot
echo Destination: %DEST_BASE%\src\addons\ForumCopilot

REM Source and destination paths
set SOURCE_DIR=plugins\FC_XenForo2\upload\src\addons\ForumCopilot
set DEST_DIR=%DEST_BASE%\src\addons\ForumCopilot

REM Check if source directory exists
if not exist "%SOURCE_DIR%" (
    echo ERROR: Source directory not found: %SOURCE_DIR%
    echo Please run this script from the project root directory.
    pause
    exit /b 1
)

REM Check if destination directory exists
if not exist "%DEST_DIR%" (
    echo ERROR: Destination directory not found: %DEST_DIR%
    echo Please ensure the server directory is accessible and DEST_BASE is set correctly.
    echo Example: set DEST_BASE=Z:\var\www\html\forums\xf2
    pause
    exit /b 1
)

echo Source: %SOURCE_DIR%
echo Destination: %DEST_DIR%
echo.

REM Copy the entire src directory recursively
echo Copying plugin files...
xcopy "%SOURCE_DIR%" "%DEST_DIR%" /E /Y /I

copy "%SOURCE_DIR%\..\..\..\forumcopilot.php" "%DEST_DIR%\..\..\..\forumcopilot.php"
