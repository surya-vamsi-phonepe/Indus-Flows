#!/bin/bash
# Copyright 2025 PhonePe Limited
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/common.sh"

echo "📋 Preparing file for upload..."

# Use the provided file path
UPLOAD_FILE_PATH="${INPUT_FILE_PATH}"

echo "UPLOAD_FILE_PATH=${UPLOAD_FILE_PATH}" >> $GITHUB_ENV

if [[ ! -f "${UPLOAD_FILE_PATH}" ]]; then
  echo "❌ Error: File not found at ${UPLOAD_FILE_PATH}"
  exit 1
fi

BASE_URL="https://developer-api.indusappstore.com/devtools"
if [[ "$INPUT_FILE_TYPE" == "aab" ]]; then
  echo "API_URL=${BASE_URL}/aab/upgrade/$PACKAGE_NAME" >> $GITHUB_ENV
elif [[ "$INPUT_FILE_TYPE" == "apk" ]]; then
  echo "API_URL=${BASE_URL}/apk/upgrade/$PACKAGE_NAME" >> $GITHUB_ENV
elif [[ "$INPUT_FILE_TYPE" == "apks" ]]; then
  echo "API_URL=${BASE_URL}/apks/upgrade/$PACKAGE_NAME" >> $GITHUB_ENV
fi

echo "✅ Upload preparation complete. File path: ${UPLOAD_FILE_PATH}"
echo "✅ API URL set to: $(cat $GITHUB_ENV | grep API_URL | cut -d= -f2)"
