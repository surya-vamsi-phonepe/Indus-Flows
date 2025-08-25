#!/bin/bash
# Copyright 2025 PhonePe Limited
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/common.sh"

echo "📤 Uploading $INPUT_FILE_TYPE file to Indus Appstore..."

CURL_CMD="curl -X POST -H \"Authorization: O-Bearer $INPUT_API_TOKEN\" -H \"Content-Type: multipart/form-data\" -F \"file=@$UPLOAD_FILE_PATH\" -F \"releaseNotes=$INPUT_RELEASE_NOTES\""

if [[ "$INPUT_FILE_TYPE" == "aab" && -n "$INPUT_KEYSTORE_SOURCE" && "$INPUT_KEYSTORE_SOURCE" != "none" && -f "$KEYSTORE_FILE_PATH" ]]; then
  echo "Including keystore for AAB upload..."
  CURL_CMD="${CURL_CMD} -F \"file=@$KEYSTORE_FILE_PATH\" -F \"keystorePassword=$INPUT_KEYSTORE_PASSWORD\" -F \"keystoreAlias=$INPUT_KEY_ALIAS\" -F \"keyPassword=$INPUT_KEY_PASSWORD\""
fi

CURL_CMD="${CURL_CMD} -w \"%{http_code}\" -o response.txt \"$API_URL\""

echo "Making API request to $API_URL..."
RESPONSE=$(eval ${CURL_CMD})

HTTP_STATUS=${RESPONSE: -3}

RESPONSE=$(tail -n1 response.txt)

echo "Response from server:"
echo $RESPONSE
if [[ $HTTP_STATUS -ge 200 && $HTTP_STATUS -lt 300 ]]; then
  echo "✅ Successfully uploaded $INPUT_FILE_TYPE to Indus Appstore!"
else
  echo "❌ Failed to upload $INPUT_FILE_TYPE to Indus Appstore. HTTP status: $HTTP_STATUS"
  exit 1
fi