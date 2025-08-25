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
    log_section "Keystore Setup"
    
    if setup_keystore; then
        log_success "Keystore setup completed successfully"
        exit 0
    else
        log_error "Keystore setup failed"
        exit 1
    fi
}

main "$@"
