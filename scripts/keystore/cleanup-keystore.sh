#!/bin/bash
# Copyright 2025 PhonePe Limited
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/common.sh"
source "$SCRIPT_DIR/../utils/keystore.sh"

main() {
    log_section "Cleanup Process"
    
    set +e
    
    cleanup_keystore
    
    cleanup_temp_dir
    
    log_success "Cleanup process completed"
    exit 0
}

main "$@"
