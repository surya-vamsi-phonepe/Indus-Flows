#!/bin/bash
# Copyright 2025 PhonePe Limited
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_operation_mode() {
    local mode="${INPUT_OPERATION_MODE:-deploy_only}"
    
    if [[ "$mode" != "deploy_only" ]]; then
        log_error "Currently only 'deploy_only' operation mode is supported"
        log_info "Operation mode provided: $mode"
        return 1
    fi
    
    log_debug "Operation mode validation passed: $mode"
    return 0
}

validate_file_type() {
    local file_type="$INPUT_FILE_TYPE"
    local valid_types=("apk" "aab" "apks")
    
    if [[ -z "$file_type" ]]; then
        log_error "File type is required"
        return 1
    fi
    
    local is_valid=false
    for valid_type in "${valid_types[@]}"; do
        if [[ "$file_type" == "$valid_type" ]]; then
            is_valid=true
            break
        fi
    done
    
    if [[ "$is_valid" != "true" ]]; then
        log_error "Invalid file type: $file_type"
        log_info "Valid types: ${valid_types[*]}"
        return 1
    fi
    
    # Validate keystore requirement for AAB files
    if [[ "$file_type" == "aab" ]]; then
        local keystore_source="${INPUT_KEYSTORE_SOURCE:-file}"
        if [[ "$keystore_source" == "none" ]]; then
            log_error "Keystore source is required when file type is 'aab'"
            return 1
        fi
    fi
    
    log_debug "File type validation passed: $file_type"
    return 0
}

validate_api_token() {
    local token="$INPUT_API_TOKEN"
    
    if [[ -z "$token" ]]; then
        log_error "API token is required"
        return 1
    fi
    
    if [[ ${#token} -lt 20 ]]; then
        log_error "API token appears to be too short"
        return 1
    fi
    
    log_debug "API token validation passed"
    return 0
}

validate_package_info() {
    local auto_detect="$INPUT_AUTO_DETECT_PACKAGE"
    local package_name="$INPUT_PACKAGE_NAME"
    
    if [[ "$auto_detect" == "true" ]]; then
        log_info "Package auto-detection enabled, skipping manual package validation"
        return 0
    fi
    
    if [[ -z "$package_name" ]]; then
        log_error "Package name is required when auto-detection is disabled"
        return 1
    fi
    
    if [[ ! "$package_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$ ]]; then
        log_error "Invalid package name format: $package_name"
        log_info "Package name should follow Java package naming convention (e.g., com.example.app)"
        return 1
    fi
    
    log_debug "Package info validation passed"
    return 0
}



validate_keystore_source() {
    local keystore_source="${INPUT_KEYSTORE_SOURCE:-file}"
    local valid_sources=("base64" "cdn" "script" "encrypted_file" "file" "none")
    
    local is_valid=false
    for valid_source in "${valid_sources[@]}"; do
        if [[ "$keystore_source" == "$valid_source" ]]; then
            is_valid=true
            break
        fi
    done
    
    if [[ "$is_valid" != "true" ]]; then
        log_error "Invalid keystore source: $keystore_source"
        log_info "Valid sources: ${valid_sources[*]}"
        return 1
    fi
    
    log_debug "Keystore source validation passed: $keystore_source"
    return 0
}

validate_keystore_configuration() {
    local keystore_source="${INPUT_KEYSTORE_SOURCE:-file}"
    
    validate_keystore_source || return 1
    
    case "$keystore_source" in
        "base64")
            validate_env_var "INPUT_KEYSTORE_BASE64" true || return 1
            ;;
        "cdn")
            validate_env_var "INPUT_KEYSTORE_CDN_URL" true || return 1
            validate_url "$INPUT_KEYSTORE_CDN_URL" "Keystore CDN" || return 1
            ;;
        "script")
            validate_env_var "INPUT_KEYSTORE_SCRIPT_PATH" true || return 1
            validate_file_path "$INPUT_KEYSTORE_SCRIPT_PATH" "Keystore script" || return 1
            ;;
        "encrypted_file")
            validate_env_var "INPUT_KEYSTORE_ENCRYPTED_PATH" true || return 1
            validate_env_var "INPUT_KEYSTORE_ENCRYPTION_KEY" true || return 1
            validate_file_path "$INPUT_KEYSTORE_ENCRYPTED_PATH" "Encrypted keystore" || return 1
            ;;
        "file")
            validate_env_var "INPUT_KEYSTORE_PATH" true || return 1
            validate_file_path "$INPUT_KEYSTORE_PATH" "Keystore" || return 1
            ;;
    esac
    
    if [[ "$keystore_source" != "none" ]]; then
        validate_env_var "INPUT_KEYSTORE_PASSWORD" true || return 1
        validate_env_var "INPUT_KEY_ALIAS" true || return 1
        validate_env_var "INPUT_KEY_PASSWORD" true || return 1
    fi
    
    log_debug "Keystore configuration validation passed"
    return 0
}

validate_deployment_file() {
    local file_path="$INPUT_FILE_PATH"
    
    if [[ -z "$file_path" ]]; then
        log_error "File path is required"
        return 1
    fi
    
    validate_file_path "$file_path" "Deployment file" || return 1
    
    if [[ ! -f "$file_path" ]]; then
        log_error "Deployment file does not exist: $file_path"
        return 1
    fi
    
    log_debug "Deployment file validation passed: $file_path"
    return 0
}

validate_boolean_parameters() {
    local boolean_params=(
        "INPUT_AUTO_DETECT_PACKAGE"
        "INPUT_KEYSTORE_VALIDATION" 
        "INPUT_VERIFY_BUILD"
    )
    
    for param in "${boolean_params[@]}"; do
        local value="${!param}"
        if [[ -n "$value" && "$value" != "true" && "$value" != "false" ]]; then
            log_error "Invalid boolean value for $param: $value (must be 'true' or 'false')"
            return 1
        fi
    done
    
    log_debug "Boolean parameters validation passed"
    return 0
}



validate_all_inputs() {
    log_section "Validating input parameters"
    
    local validation_errors=0
    
    validate_operation_mode || ((validation_errors++))
    validate_file_type || ((validation_errors++))
    validate_api_token || ((validation_errors++))
    validate_boolean_parameters || ((validation_errors++))
    
    validate_package_info || ((validation_errors++))
    validate_deployment_file || ((validation_errors++))
    
    validate_keystore_configuration || ((validation_errors++))
    
    if [[ $validation_errors -eq 0 ]]; then
        log_success "All input validation checks passed"
        return 0
    else
        log_error "Validation failed with $validation_errors error(s)"
        log_info "Please check the error messages above and fix the configuration"
        return 1
    fi
}

export -f validate_operation_mode validate_file_type validate_api_token
export -f validate_package_info validate_keystore_configuration
export -f validate_all_inputs
