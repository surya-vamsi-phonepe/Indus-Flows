#!/bin/bash
# Copyright 2025 PhonePe Limited
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_keystore() {
    local keystore_path="$1"
    local password="$2"
    local alias="$3"
    
    log_debug "Starting keystore validation for: $keystore_path"
    
    if [[ "$INPUT_KEYSTORE_VALIDATION" != "true" ]]; then
        log_info "Keystore validation skipped (disabled)"
        return 0
    fi
    
    if [[ ! -f "$keystore_path" ]]; then
        log_error "Keystore file not found: $keystore_path"
        return 1
    fi
    
    if ! command_exists keytool; then
        log_warning "keytool not available for validation"
        return 0
    fi
    
    log_info "Validating keystore..."
    
    # Use a temporary file for keytool output to avoid logging sensitive info
    local temp_output="$TEMP_DIR/keytool_output.tmp"

    echo "Keystore path: $keystore_path"
    echo "Keystore path: $TEMP_DIR"
    
    if keytool -list -keystore "$keystore_path" \
               -storepass "$password" \
               -alias "$alias" > "$temp_output" 2>&1; then
        log_success "Keystore validation successful"
        secure_remove "$temp_output"
        return 0
    else
        log_error "Keystore validation failed - please check your credentials"
        secure_remove "$temp_output"
        return 1
    fi
}

download_keystore() {
    local url="$1"
    local output_path="$2"
    local auth_header="$3"
    
    log_info "Downloading keystore from secure source..."
    
    # Validate URL
    validate_url "$url" "Keystore download"
    
    # Prepare curl command with security options
    local curl_cmd=(
        curl
        -fsSL
        --max-time 60
        --retry 3
        --retry-delay 2
        --output "$output_path"
        -H "User-Agent: GitHub-Actions-Indus-Store"
    )
    
    # Add authorization header if provided
    if [[ -n "$auth_header" ]]; then
        curl_cmd+=(-H "Authorization: $auth_header")
    fi
    
    # Add URL
    curl_cmd+=("$url")
    
    # Execute download with retry
    if retry_command 3 5 "${curl_cmd[@]}"; then
        chmod 600 "$output_path"
        log_success "Keystore downloaded successfully"
        return 0
    else
        log_error "Failed to download keystore after retries"
        return 1
    fi
}

decode_base64_keystore() {
    local base64_content="$1"
    local output_path="$2"
    
    log_info "Decoding base64 keystore..."
    
    if [[ -z "$base64_content" ]]; then
        log_error "Base64 keystore content is empty"
        return 1
    fi
    
    # Decode base64 content
    if echo "$base64_content" | base64 -d > "$output_path" 2>/dev/null; then
        chmod 600 "$output_path"
        log_success "Base64 keystore decoded successfully"
        return 0
    else
        log_error "Failed to decode base64 keystore"
        return 1
    fi
}

execute_keystore_script() {
    local script_path="$1"
    local script_args="$2"
    local output_path="$3"
    
    log_info "Executing custom keystore script: $script_path"
    
    validate_file_path "$script_path" "Keystore script"
    
    if [[ ! -f "$script_path" ]]; then
        log_error "Keystore script not found: $script_path"
        return 1
    fi
    
    if [[ ! -x "$script_path" ]]; then
        log_warning "Making script executable: $script_path"
        chmod +x "$script_path"
    fi
    
    export KEYSTORE_OUTPUT_PATH="$output_path"
    
    local cmd=("$script_path")
    if [[ -n "$script_args" ]]; then
        # Split args safely
        IFS=' ' read -ra args_array <<< "$script_args"
        cmd+=("${args_array[@]}")
    fi
    
    if measure_time "${cmd[@]}"; then
        if [[ -f "$output_path" ]]; then
            chmod 600 "$output_path"
            log_success "Custom keystore script executed successfully"
            return 0
        else
            log_error "Script completed but keystore not created at: $output_path"
            return 1
        fi
    else
        log_error "Custom keystore script failed"
        return 1
    fi
}

decrypt_keystore_file() {
    local encrypted_path="$1"
    local encryption_key="$2"
    local output_path="$3"
    
    log_info "Decrypting keystore file..."
    
    # Validate encrypted file path
    validate_file_path "$encrypted_path" "Encrypted keystore"
    
    if [[ ! -f "$encrypted_path" ]]; then
        log_error "Encrypted keystore file not found: $encrypted_path"
        return 1
    fi
    
    if [[ -z "$encryption_key" ]]; then
        log_error "Encryption key is empty"
        return 1
    fi
    
    # Check if OpenSSL is available
    if ! command_exists openssl; then
        log_error "OpenSSL not available for decryption"
        return 1
    fi
    
    # Decrypt using AES-256-CBC
    if echo "$encryption_key" | openssl enc -aes-256-cbc -d -in "$encrypted_path" -out "$output_path" -pass stdin 2>/dev/null; then
        chmod 600 "$output_path"
        log_success "Keystore decrypted successfully"
        return 0
    else
        log_error "Failed to decrypt keystore file"
        return 1
    fi
}

setup_keystore() {
    local keystore_source="${INPUT_KEYSTORE_SOURCE:-file}"
    
    log_section "Setting up keystore for signing"
    log_info "Keystore source: $keystore_source"
    
    setup_temp_dir
    
    case "$keystore_source" in
        "base64")
            validate_env_var "INPUT_KEYSTORE_BASE64" true
            decode_base64_keystore "$INPUT_KEYSTORE_BASE64" "$KEYSTORE_FILE_PATH"
            ;;
        "cdn")
            validate_env_var "INPUT_KEYSTORE_CDN_URL" true
            download_keystore "$INPUT_KEYSTORE_CDN_URL" "$KEYSTORE_FILE_PATH" "$INPUT_KEYSTORE_CDN_AUTH_HEADER"
            ;;
        "script")
            validate_env_var "INPUT_KEYSTORE_SCRIPT_PATH" true
            execute_keystore_script "$INPUT_KEYSTORE_SCRIPT_PATH" "$INPUT_KEYSTORE_SCRIPT_ARGS" "$KEYSTORE_FILE_PATH"
            ;;
        "encrypted_file")
            validate_env_var "INPUT_KEYSTORE_ENCRYPTED_PATH" true
            validate_env_var "INPUT_KEYSTORE_ENCRYPTION_KEY" true
            decrypt_keystore_file "$INPUT_KEYSTORE_ENCRYPTED_PATH" "$INPUT_KEYSTORE_ENCRYPTION_KEY" "$KEYSTORE_FILE_PATH"
            ;;
        "file")
            validate_env_var "INPUT_KEYSTORE_PATH" true
            validate_file_path "$INPUT_KEYSTORE_PATH" "Keystore"
            if [[ ! -f "$INPUT_KEYSTORE_PATH" ]]; then
                log_error "Keystore file not found: $INPUT_KEYSTORE_PATH"
                return 1
            fi
            secure_copy "$INPUT_KEYSTORE_PATH" "$KEYSTORE_FILE_PATH"
            ;;
        "none")
            log_info "Skipping keystore setup (signing disabled)"
            return 0
            ;;
        *)
            log_error "Unknown keystore source: $keystore_source"
            return 1
            ;;
    esac
    
    if [[ "$keystore_source" != "none" && -f "$KEYSTORE_FILE_PATH" ]]; then
        validate_keystore "$KEYSTORE_FILE_PATH" "$INPUT_KEYSTORE_PASSWORD" "$INPUT_KEY_ALIAS"
        
        export KEYSTORE_FILE_PATH
        export KEYSTORE_PASSWORD="$INPUT_KEYSTORE_PASSWORD"
        export KEY_ALIAS="$INPUT_KEY_ALIAS"
        export KEY_PASSWORD="$INPUT_KEY_PASSWORD"
        
        local file_size
        file_size=$(get_file_size "$KEYSTORE_FILE_PATH")
        log_success "Keystore setup completed ($(format_file_size "$file_size"))"
    fi
    
    return 0
}

cleanup_keystore() {
    log_section "Cleaning up keystore files"
    
    # Remove keystore file
    secure_remove "$KEYSTORE_FILE_PATH"
    
    # Remove signing properties
    secure_remove "$GITHUB_WORKSPACE/signing.properties"
    
    # Clean up environment variables
    unset KEYSTORE_FILE_PATH KEYSTORE_PASSWORD KEY_ALIAS KEY_PASSWORD
    unset KEYSTORE_OUTPUT_PATH
    
    # Clean up temporary directory
    cleanup_temp_dir
    
    log_success "Keystore cleanup completed"
}

export -f validate_keystore download_keystore decode_base64_keystore
export -f execute_keystore_script decrypt_keystore_file
export -f setup_keystore cleanup_keystore
