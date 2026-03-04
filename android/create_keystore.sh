#!/bin/bash

# Script to create a release keystore for Android app signing
# Run this script from the android directory

echo "Creating release keystore for ForumCopilot..."
echo ""
echo "You will be prompted to enter:"
echo "1. A password for the keystore (save this securely!)"
echo "2. The same password again to confirm"
echo "3. Your name and organization details"
echo ""

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "ERROR: Java is not found in PATH."
    echo "Please install Java or set JAVA_HOME environment variable."
    echo ""
    echo "Alternatively, you can create the keystore using Android Studio:"
    echo "1. Open your project in Android Studio"
    echo "2. Go to Build > Generate Signed Bundle / APK"
    echo "3. Select 'Android App Bundle' or 'APK'"
    echo "4. Click 'Create new...' to create a new keystore"
    echo "5. Fill in the details and save the keystore to: android/app/upload-keystore.jks"
    exit 1
fi

# Find keytool
KEYTOOL=$(find "$JAVA_HOME" -name keytool 2>/dev/null | head -1)
if [ -z "$KEYTOOL" ]; then
    KEYTOOL=$(which keytool)
fi

if [ -z "$KEYTOOL" ]; then
    echo "ERROR: keytool not found. Please install Java JDK."
    exit 1
fi

# Create keystore
$KEYTOOL -genkey -v \
  -keystore app/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload \
  -storetype JKS

echo ""
echo "Keystore created successfully at: android/app/upload-keystore.jks"
echo ""
echo "IMPORTANT: Update android/key.properties with your keystore password!"
echo "Replace YOUR_KEYSTORE_PASSWORD and YOUR_KEY_PASSWORD with the password you just entered."



