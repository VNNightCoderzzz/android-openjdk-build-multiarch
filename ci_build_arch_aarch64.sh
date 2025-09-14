#!/bin/bash
set -e

# --- 1. Setup target ---
if [[ "$BUILD_IOS" == "1" ]]; then
  export TARGET=aarch64-apple-darwin18.2
else
  export TARGET=aarch64-linux-android
fi
export TARGET_JDK=aarch64
export NDK_PREBUILT_ARCH=/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/aarch64-linux-android/bin/strip

# --- 2. Export locale UTF-8 (fix towc issue) ---
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=UTF-8

# --- 3. Patch JAXP Encodings.properties to UTF-8 if it exists ---
FILE=jaxp/src/com/sun/org/apache/xml/internal/serializer/Encodings.properties
if [ -f "$FILE" ]; then
  iconv -f ISO-8859-1 -t UTF-8 "$FILE" > "${FILE}.utf8"
  mv "${FILE}.utf8" "$FILE"
  echo "Patched $FILE to UTF-8"
else
  echo "File $FILE không tồn tại, bỏ qua patch"
fi

# --- 4. Call global build script ---
bash ci_build_global.sh
