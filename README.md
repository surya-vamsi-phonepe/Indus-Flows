# 🚀 Indus Appstore GitHub Action

<div align="center">

![Indus Appstore Banner](public/banner.svg)

**The most comprehensive GitHub Action for deploying Android apps to Indus Appstore**

*Deploy your Android apps in minutes with enterprise-grade security and comprehensive automation*

</div>

---

## 🌟 Why Choose This Action?

<table>
  <tr>
    <td align="center">🔐</td>
    <td><strong>6 Secure Keystore Options</strong><br/>From simple base64 to encrypted files and custom scripts</td>
    <td align="center">⚡</td>
    <td><strong>Lightning Fast</strong><br/>Optimized deployment with validation and secure handling</td>
  </tr>
  <tr>
    <td align="center">🛡️</td>
    <td><strong>Enterprise Security</strong><br/>Automatic cleanup, validation, and secure file handling</td>
    <td align="center">🔧</td>
    <td><strong>Zero Configuration</strong><br/>Auto-detects packages, validates files, suggests optimizations</td>
  </tr>
  <tr>
    <td align="center">📊</td>
    <td><strong>Comprehensive Validation</strong><br/>APK/AAB/APKS file validation and keystore verification</td>
    <td align="center">🚀</td>
    <td><strong>Flexible Deployment</strong><br/>Deploy-only mode with support for all Android file types</td>
  </tr>
</table>

---

## � Prerequisites

> ⚠️ **Important**: Your app must be **published at least once** on the Indus Appstore before using this action for automated deployments.

## �🚀 Quick Start (30 seconds)

### 1. 📝 Basic APK Deployment

Create `.github/workflows/deploy.yml` in your repository:

```yaml
name: Deploy to Indus Appstore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy APK to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          file_path: './app-release.apk'
          file_type: 'apk'
          package_name: 'com.example.myapp'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          release_notes: 'Automated deployment via GitHub Actions'
```

### 2. 🔐 AAB Deployment with Keystore

For AAB files, you need to include keystore information:

```yaml
- name: Deploy AAB to Indus Appstore
  uses: indusappstore/appstore-release@v1
  with:
    file_path: './app-release.aab'
    file_type: 'aab'
    package_name: 'com.example.myapp'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    
    # Keystore configuration
    keystore_source: 'base64'
    keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
```

---

## 📋 Configuration Reference

### 📂 Core Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `api_token` | Indus Appstore Developer API Token | ✅ Yes | - |
| `file_path` | Path to APK/AAB/APKS file | ✅ Yes | - |
| `file_type` | File type: `apk`, `aab`, or `apks` | ✅ Yes | `apk` |
| `package_name` | Android package name | No* | Auto-detected |
| `operation_mode` | Operation mode (future use) | No | `deploy_only` |
| `release_notes` | Release notes for deployment | No | `'Deployed via GitHub Actions'` |

*Required if `auto_detect_package` is `false`

### 🔐 Keystore Configuration (Required for AAB files)

| Parameter | Description | Required | Example |
|-----------|-------------|----------|---------|
| `keystore_source` | Source type | For AAB | `base64`, `cdn`, `script`, `encrypted_file`, `file`, `none` |
| `keystore_password` | Keystore password | For AAB | `${{ secrets.KEYSTORE_PASSWORD }}` |
| `key_alias` | Key alias | For AAB | `${{ secrets.KEY_ALIAS }}` |
| `key_password` | Key password | For AAB | `${{ secrets.KEY_PASSWORD }}` |

#### Keystore Source Options

<details>
<summary><b>📦 Base64 Keystore (Recommended)</b></summary>

```yaml
keystore_source: 'base64'
keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
```

**Setup**: `base64 -i your-keystore.jks | pbcopy`
</details>

<details>
<summary><b>🌐 CDN Keystore</b></summary>

```yaml
keystore_source: 'cdn'
keystore_cdn_url: ${{ secrets.KEYSTORE_CDN_URL }}
keystore_cdn_auth_header: ${{ secrets.CDN_AUTH_TOKEN }}
```
</details>

<details>
<summary><b>📜 Custom Script Keystore</b></summary>

```yaml
keystore_source: 'script'
keystore_script_path: './scripts/fetch-keystore.sh'
keystore_script_args: 'production'
```
</details>

<details>
<summary><b>🔒 Encrypted File Keystore</b></summary>

```yaml
keystore_source: 'encrypted_file'
keystore_encrypted_path: './keystore/encrypted-keystore.enc'
keystore_encryption_key: ${{ secrets.KEYSTORE_ENCRYPTION_KEY }}
```
</details>

<details>
<summary><b>📁 File Keystore</b></summary>

```yaml
keystore_source: 'file'
keystore_path: './keystore/app-keystore.jks'
```
</details>

### 🔧 Advanced Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `auto_detect_package` | Auto-detect package name from manifest | `false` |
| `keystore_validation` | Validate keystore before use | `true` 

---

## 🚀 Optimized Workflow Examples

### 📱 Simple APK Deployment
Perfect for basic apps that don't require signing:

```yaml
name: Deploy APK

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy APK
        uses: indusappstore/appstore-release@v1
        with:
          file_path: './app-release.apk'
          file_type: 'apk'
          package_name: 'com.example.myapp'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
```

### 🔐 AAB with Base64 Keystore
Most secure and common approach for production apps:

```yaml
name: Deploy AAB with Secure Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy AAB
        uses: indusappstore/appstore-release@v1
        with:
          file_path: './app-release.aab'
          file_type: 'aab'
          package_name: 'com.example.myapp'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          keystore_source: 'base64'
          keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          release_notes: |
            🚀 Release ${{ github.run_number }}
            📝 ${{ github.event.head_commit.message }}
```

### 🏗️ Build and Deploy Workflow
Complete workflow with build, test, and deploy stages:

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      artifact-name: ${{ steps.build.outputs.artifact-name }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'
          
      - name: Cache Gradle
        uses: actions/cache@v3
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
          key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*') }}
          
      - name: Build AAB
        id: build
        run: |
          ./gradlew bundleRelease
          echo "artifact-name=app-release-${{ github.run_number }}" >> $GITHUB_OUTPUT
          
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: ${{ steps.build.outputs.artifact-name }}
          path: app/build/outputs/bundle/release/app-release.aab
          retention-days: 1

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: ${{ needs.build.outputs.artifact-name }}
          
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          file_path: './app-release.aab'
          file_type: 'aab'
          package_name: 'com.example.myapp'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          keystore_source: 'base64'
          keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
```

### 🔧 Custom Keystore Fetching
For advanced setups with cloud storage:

```yaml
name: Deploy with Custom Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup AWS
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
          
      - name: Deploy with Custom Keystore
        uses: indusappstore/appstore-release@v1
        with:
          file_path: './app-release.aab'
          file_type: 'aab'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          keystore_source: 'script'
          keystore_script_path: './scripts/fetch-keystore-from-s3.sh'
          keystore_script_args: 'production ${{ secrets.S3_BUCKET }}'
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
```

---

## 🔐 Setup Guide

> ⚠️ **CRITICAL REQUIREMENT**: Your app must be **manually published at least once** on the Indus Appstore before using this action. This action is designed for **updates to existing apps**, not initial app submissions.

### 1. 📱 Publish Your App First
1. **Manual Upload Required**: Use the Indus Appstore Developer Console to upload your app manually for the first time
2. **Complete Store Listing**: Fill in all required app information, descriptions, screenshots, etc.
3. **Initial Review**: Wait for your app to be reviewed and published
4. **Note Package Name**: Remember the exact package name used during publication

### 2. 🔑 Get Your API Token
1. Visit [Indus Appstore Developer Platform](https://developer.indusappstore.com)
2. Navigate to **Tools & Resources** section
3. Enable a API token
4. Copy the token securely

### 3. 🔒 Setup GitHub Secrets
Go to your repository **Settings** → **Secrets and variables** → **Actions** and add:

#### Required Secrets
| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `INDUS_APP_STORE_API_TOKEN` | Your API token | From Indus Developer Platform |

#### For AAB Files (Keystore Required)
| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `KEYSTORE_BASE64` | Base64 encoded keystore | `base64 -i your-keystore.jks \| pbcopy` |
| `KEYSTORE_PASSWORD` | Keystore password | From keystore creation |
| `KEY_ALIAS` | Key alias | From keystore creation |
| `KEY_PASSWORD` | Key password | From keystore creation |

### 4. 📱 Prepare Your App Files
Ensure your APK, AAB, or APKS files are available in your repository or build artifacts.

### 5. 🚀 Create Workflow
Use one of the examples above or create your custom workflow.

### 6. ✅ Test and Deploy
Push your changes and monitor the Actions tab for deployment progress.

---

---

## 🔐 Keystore Security Options

Choose the security level that fits your needs:

<table>
  <tr>
    <th>Source</th>
    <th>Security Level</th>
    <th>Use Case</th>
    <th>Setup Difficulty</th>
    <th>Enterprise Ready</th>
  </tr>
  <tr>
    <td><code>base64</code></td>
    <td>🔒 High</td>
    <td>Most common, GitHub Secrets</td>
    <td>⭐⭐</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><code>cdn</code></td>
    <td>🔒 High</td>
    <td>Team sharing, CDN storage</td>
    <td>⭐⭐⭐</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><code>script</code></td>
    <td>🔐 Very High</td>
    <td>Custom logic, cloud storage</td>
    <td>⭐⭐⭐⭐</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><code>encrypted_file</code></td>
    <td>🔒 High</td>
    <td>Encrypted in repository</td>
    <td>⭐⭐⭐</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><code>file</code></td>
    <td>⚠️ Low</td>
    <td>Development only</td>
    <td>⭐</td>
    <td>❌</td>
  </tr>
  <tr>
    <td><code>none</code></td>
    <td>N/A</td>
    <td>Unsigned builds</td>
    <td>⭐</td>
    <td>N/A</td>
  </tr>
</table>

---

## 📚 Complete Examples

<details>
<summary><b>🔐 Base64 Keystore (Recommended for Most Users)</b></summary>

**Perfect for:** Individual developers, small teams, GitHub Secrets

```yaml
name: Deploy with Base64 Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          # File configuration
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          auto_detect_package: 'true'
          
          # Keystore configuration
          keystore_source: 'base64'
          keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          # Security options
          keystore_validation: 'true'
          verify_build: 'true'
          
          # Release notes
          release_notes: |
            🚀 Version ${{ github.ref_name }}
            
            Changes in this release:
            ${{ github.event.head_commit.message }}
```

**Setup:**
```bash
# 1. Encode your keystore
base64 -i your-keystore.jks | pbcopy

# 2. Add to GitHub Secrets as KEYSTORE_BASE64
```

</details>

<details>
<summary><b>🌐 CDN Keystore (Great for Teams)</b></summary>

**Perfect for:** Teams, centralized keystore management

```yaml
name: Deploy with CDN Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4        - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          # File configuration
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          
          # Keystore from CDN
          keystore_source: 'cdn'
          keystore_cdn_url: ${{ secrets.KEYSTORE_CDN_URL }}
          keystore_cdn_auth_header: 'Bearer ${{ secrets.CDN_AUTH_TOKEN }}'
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          # Standard options
          file_type: 'aab'
          auto_detect_package: 'true'
          keystore_validation: 'true'
```

</details>

<details>
<summary><b>🛠️ Custom Script Keystore (Maximum Flexibility)</b></summary>

**Perfect for:** Cloud storage integration, custom logic

```yaml
name: Deploy with Custom Script

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          # File configuration
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          
          # Custom keystore script
          keystore_source: 'script'
          keystore_script_path: './scripts/fetch-keystore.sh'
          keystore_script_args: 'production ${{ github.ref_name }}'
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          # Standard options
          file_type: 'aab'
          auto_detect_package: 'true'
          keystore_validation: 'true'
```

**Example Script (AWS S3):**
```bash
#!/bin/bash
# scripts/fetch-keystore.sh
set -e

ENVIRONMENT=$1
VERSION=$2

# Download from S3
aws s3 cp "s3://my-keystores/${ENVIRONMENT}-keystore.jks" "$KEYSTORE_OUTPUT_PATH"
echo "✅ Keystore fetched for $ENVIRONMENT environment"
```

**Creating Complete Keystore Fetch Workflows:**

For comprehensive keystore management, create workflows that handle fetching and deployment in one step:

```yaml
name: Multi-Environment Keystore Deployment

on:
  push:
    branches: [main, staging, dev]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: choice
        options: [production, staging, development]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment || 'production' }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up cloud credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Deploy with Environment-Specific Keystore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          
          # Dynamic keystore fetching
          keystore_source: 'script'
          keystore_script_path: './scripts/fetch-keystore.sh'
          keystore_script_args: '${{ github.event.inputs.environment || "production" }} ${{ github.ref_name }}'
          
          # Environment-specific credentials
          keystore_password: ${{ secrets[format('{0}_KEYSTORE_PASSWORD', github.event.inputs.environment || 'PRODUCTION')] }}
          key_alias: ${{ secrets[format('{0}_KEY_ALIAS', github.event.inputs.environment || 'PRODUCTION')] }}
          key_password: ${{ secrets[format('{0}_KEY_PASSWORD', github.event.inputs.environment || 'PRODUCTION')] }}
          
          # API configuration
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          auto_detect_package: 'true'
          
          # Security and validation
          keystore_validation: 'true'
          
          release_notes: |
            Environment: ${{ github.event.inputs.environment || 'production' }}
            Branch: ${{ github.ref_name }}
            Build: ${{ github.run_number }}
            Commit: ${{ github.sha }}
```

**Advanced Custom Keystore Scripts:**

```bash
#!/bin/bash
# scripts/fetch-keystore.sh - Multi-cloud keystore fetching
set -e

ENVIRONMENT=$1
VERSION=$2
CLOUD_PROVIDER="${CLOUD_PROVIDER:-aws}"

echo "🔐 Fetching $ENVIRONMENT keystore from $CLOUD_PROVIDER"

case "$CLOUD_PROVIDER" in
  "aws")
    aws s3 cp "s3://my-keystores/${ENVIRONMENT}-keystore.jks" "$KEYSTORE_OUTPUT_PATH"
    ;;
  "gcp")
    gsutil cp "gs://my-keystores/${ENVIRONMENT}-keystore.jks" "$KEYSTORE_OUTPUT_PATH"
    ;;
  "azure")
    az storage blob download \
      --container-name keystores \
      --name "${ENVIRONMENT}-keystore.jks" \
      --file "$KEYSTORE_OUTPUT_PATH"
    ;;
  *)
    echo "❌ Unsupported cloud provider: $CLOUD_PROVIDER"
    exit 1
    ;;
esac

echo "✅ Keystore fetched successfully"
```

**🔄 Two-Stage Workflow Pattern (Advanced)**

For enterprise scenarios, create **separate workflows** where keystore fetching and deployment are independent processes:

<details>
<summary><b>📋 Click to see Two-Stage Workflow Implementation</b></summary>

**Stage 1: Keystore Fetch Workflow** (`.github/workflows/fetch-keystore.yml`):
```yaml
name: Fetch Keystore and Trigger Deploy

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [production, staging, development]

jobs:
  fetch-keystore:
    runs-on: ubuntu-latest
    outputs:
      keystore-ready: ${{ steps.keystore.outputs.ready }}
    steps:
      - uses: actions/checkout@v4
      
      # TODO: Configure your cloud provider credentials
      # - uses: aws-actions/configure-aws-credentials@v4
      # - uses: google-github-actions/auth@v2  
      # - uses: azure/login@v2
      
      - name: Fetch keystore
        id: keystore
        run: |
          # TODO: Implement your keystore fetching logic
          # Examples (uncomment and modify as needed):
          # aws s3 cp "s3://my-keystores/production-keystore.jks" "keystore.jks"
          # gsutil cp "gs://my-keystores/production-keystore.jks" "keystore.jks" 
          # curl -H "Authorization: Bearer $TOKEN" "$API_URL/keystore" -o keystore.jks
          
          # For demo purposes, create a placeholder
          echo "placeholder-keystore" > keystore.jks
          base64 -i keystore.jks > keystore.b64
          echo "ready=true" >> $GITHUB_OUTPUT
      
      - name: Upload keystore artifact
        uses: actions/upload-artifact@v4
        with:
          name: keystore-${{ github.run_number }}
          path: keystore.b64
          retention-days: 1

  # 🚀 Automatically trigger our GitHub Action
  trigger-deploy:
    needs: fetch-keystore
    if: needs.fetch-keystore.outputs.keystore-ready == 'true'
    uses: ./.github/workflows/build-and-deploy.yml
    with:
      keystore-artifact: keystore-${{ github.run_number }}
    secrets: inherit
```

**Stage 2: Build and Deploy Workflow** (`.github/workflows/build-and-deploy.yml`):
```yaml
name: Build and Deploy with Fetched Keystore

on:
  workflow_call:
    inputs:
      keystore-artifact:
        required: true
        type: string

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Download keystore from previous workflow
        uses: actions/download-artifact@v4
        with:
          name: ${{ inputs.keystore-artifact }}
      
      # 🎯 This is where our action gets called with the fetched keystore
      - name: Deploy with fetched keystore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          
          # Use the keystore from the previous workflow
          : 'true'
          keystore_source: 'base64'
          keystore_base64: ${{ env.KEYSTORE_BASE64 }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          # Action configuration
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          auto_detect_package: 'true'
          verify_build: 'true'
        env:
          KEYSTORE_BASE64: ${{ hashFiles('keystore.b64') && 'FROM_ARTIFACT' || secrets.FALLBACK_KEYSTORE_BASE64 }}
```

**💡 Usage Benefits:**
- ✅ **Easy setup**: Just create two YAML files in `.github/workflows/`
- ✅ **Flexible keystore sources**: Adapt fetch step to your infrastructure  
- ✅ **Automatic triggering**: Deploy workflow runs automatically after keystore fetch
- ✅ **Security**: Short-lived keystore artifacts, automatic cleanup
- ✅ **Reusable**: Deploy workflow can be triggered by different keystore sources
- ✅ **GitHub native**: Uses standard GitHub Actions features (`workflow_call`, artifacts)

**🛠️ Quick Setup:**
1. Copy the workflows to your `.github/workflows/` folder
2. Modify the keystore fetching logic in Stage 1 for your setup
3. Configure your secrets in GitHub repository settings
4. Push to main or trigger manually - that's it! 🚀

</details>

</details>



<details>
<summary><b>🔐 Encrypted File (Version Control Safe)</b></summary>

**Perfect for:** Storing encrypted keystores in repository

```yaml
name: Deploy with Encrypted Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          # File configuration
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          
          # Encrypted keystore file
          keystore_source: 'encrypted_file'
          keystore_encrypted_path: './keystore/production.jks.enc'
          keystore_encryption_key: ${{ secrets.ENCRYPTION_KEY }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          
          # Standard options
          file_type: 'aab'
          auto_detect_package: 'true'
          keystore_validation: 'true'
```

**Setup:**
```bash
# Encrypt your keystore
openssl enc -aes-256-cbc -in keystore.jks -out keystore.jks.enc
```

</details>

<details>
<summary><b>📦 Deploy Only Mode (Pre-built Apps)</b></summary>

**Perfect for:** Deploying pre-built APK/AAB files

```yaml
name: Deploy Pre-built App

on:
  workflow_run:
    workflows: ["Build"]
    types: [completed]
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Download build artifact
        uses: actions/download-artifact@v4
        with:
          name: app-release
          path: ./build/
          
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          
          # Pre-built file
          file_path: './build/app-release.aab'
          file_type: 'aab'
          
          # Package info (or use auto-detection)
          auto_detect_package: 'true'
          # package_name: 'com.example.app'
          # app_name: 'My App'
          
          release_notes: 'Automated deployment from build workflow'
```

</details>

---

<div align="center">

Made with ❤️ by the [Indus Appstore Team](https://indusappstore.com)

</div>
    package_name: 'com.example.app'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
```

### 2. Deploy with Enhanced Security

```yaml
- name: Deploy to Indus Appstore
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_path: 'app/build/outputs/bundle/release/app-release.aab'
    file_type: 'aab'
    auto_detect_package: 'true'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    keystore_source: 'base64'
    keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
    keystore_validation: 'true'
```

### 3. Set Up API Token and Secrets

1. Go to your GitHub repository
2. Click on "Settings" > "Secrets and variables" > "Actions"
3. Add these secrets:
   - `INDUS_APP_STORE_API_TOKEN`: Your Indus Appstore API token
   - `KEYSTORE_BASE64`: Base64 encoded keystore file
   - `KEYSTORE_PASSWORD`: Keystore password
   - `KEY_ALIAS`: Key alias in the keystore
   - `KEY_PASSWORD`: Key password

## 📋 Advanced Usage Examples

<details>
<summary><b>🔐 Base64 Keystore (Recommended)</b></summary>

```yaml
name: Build and Deploy with Base64 Keystore

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          file_path: 'app/build/outputs/bundle/release/app-release.aab'
          file_type: 'aab'
          auto_detect_package: 'true'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          keystore_source: 'base64'
          keystore_base64: ${{ secrets.KEYSTORE_BASE64 }}
          keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
          key_alias: ${{ secrets.KEY_ALIAS }}
          key_password: ${{ secrets.KEY_PASSWORD }}
          keystore_validation: 'true'
          release_notes: |
            Version: ${{ github.ref_name }}
            Build: ${{ github.run_number }}
            Commit: ${{ github.sha }}
```

**Setup Instructions:**
```bash
# Encode your keystore to base64
base64 -i your-keystore.jks | pbcopy
# Add to GitHub Secrets as KEYSTORE_BASE64
```

</details>

<details>
<summary><b>🌐 CDN Keystore</b></summary>

```yaml
- name: Deploy with CDN Keystore
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_type: 'aab'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    keystore_source: 'cdn'
    keystore_cdn_url: ${{ secrets.KEYSTORE_CDN_URL }}
    keystore_cdn_auth_header: ${{ secrets.CDN_AUTH_TOKEN }}
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
```

**Use Cases:**
- Corporate environments with secure file servers
- Multi-team scenarios with centralized keystore management
- Dynamic keystore rotation

</details>

<details>
<summary><b>📜 Custom Script Keystore</b></summary>

```yaml
- name: Setup AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy with Custom Script
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_path: 'app/build/outputs/bundle/release/app-release.aab'
    file_type: 'aab'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    keystore_source: 'script'
    keystore_script_path: './scripts/fetch-keystore-from-s3.sh'
    keystore_script_args: '${{ secrets.S3_BUCKET }} ${{ secrets.S3_KEYSTORE_PATH }}'
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
  env:
    S3_BUCKET: ${{ secrets.S3_BUCKET }}
    S3_KEY_PATH: ${{ secrets.S3_KEYSTORE_PATH }}
```

**Custom Script Requirements:**
- Must create keystore at `$KEYSTORE_OUTPUT_PATH`
- Should handle errors gracefully
- Must be executable

</details>



<details>
<summary><b>🔒 Encrypted File Keystore</b></summary>

```yaml
- name: Deploy with Encrypted Keystore
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_path: 'app/build/outputs/bundle/release/app-release.aab'
    file_type: 'aab'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    keystore_source: 'encrypted_file'
    keystore_encrypted_path: './keystore/encrypted-keystore.enc'
    keystore_encryption_key: ${{ secrets.KEYSTORE_ENCRYPTION_KEY }}
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
```

**Setup Instructions:**
```bash
# Encrypt your keystore
openssl enc -aes-256-cbc -in keystore.jks -out keystore.enc -k "your-password"
# Commit encrypted file to repository
# Store encryption key in GitHub Secrets
```

</details>



<details>
<summary><b>🔍 Auto-detect Package Name</b></summary>

```yaml
- name: Deploy to Indus Appstore with Auto-detection
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_path: 'app/build/outputs/apk/release/app-release.apk'
    file_type: 'apk'
    auto_detect_package: 'true'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
```
</details>

<details>
<summary><b>📦 AAB with Keystore</b></summary>

```yaml
- name: Deploy AAB to Indus Appstore
  uses: indusappstore/appstore-release@v1
  with:
    operation_mode: 'deploy_only'
    file_path: 'app/build/outputs/bundle/release/app-release.aab'
    file_type: 'aab'
    package_name: 'com.example.app'
    api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
    keystore_path: ${{ secrets.KEYSTORE_PATH }}
    keystore_password: ${{ secrets.KEYSTORE_PASSWORD }}
    key_alias: ${{ secrets.KEY_ALIAS }}
    key_password: ${{ secrets.KEY_PASSWORD }}
```
</details>

<details>
<summary><b>🔄 Complete Workflow Example</b></summary>

```yaml
name: Deploy to Indus Appstore

on:
  workflow_run:
    workflows: ["Android Build"]  # Replace with your actual build workflow name
    types:
      - completed
    branches: [main, master]

  workflow_dispatch:  # Allow manual triggering

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Deploy to Indus Appstore
        uses: indusappstore/appstore-release@v1
        with:
          operation_mode: 'deploy_only'
          file_path: 'app/build/outputs/apk/release/app-release.apk'
          file_type: 'apk'
          auto_detect_package: 'true'
          api_token: ${{ secrets.INDUS_APP_STORE_API_TOKEN }}
          release_notes: 'Automated release via GitHub Actions'
```
</details>

## 📝 Configuration Options

| Parameter | Description | Required | Default |
|:---------|:------------|:--------:|:-------:|
| `operation_mode` | Operation mode (only `deploy_only` supported) | ✅ | `deploy_only` |
| `file_path` | Path to the AAB, APK, or APKs file | ✅ | - |
| `file_type` | Type of file to upload (`aab`, `apk`, or `apks`) | ✅ | `apk` |
| `package_name` | Android package name (e.g. com.example.app) | ⚠️** | - |
| `api_token` | Indus Appstore API Token | ✅ | - |
| `release_notes` | Release notes for this version | ❌ | `New release via GitHub Actions` |
| `keystore_path` | Path to keystore file (for AAB signing) | ❌ | - |
| `keystore_password` | Password for keystore | ❌ | - |
| `key_alias` | Key alias in keystore | ❌ | - |
| `key_password` | Password for key | ❌ | - |
| `auto_detect_package` | Auto-detect package name from build.gradle | ❌ | `false` |

\* Required if `operation_mode` is `deploy_only`  
\** Not required if `auto_detect_package` is `true`

## 🔐 Secrets Setup

To use the keystore for AAB signing, add these additional secrets:

- `KEYSTORE_PATH`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`

## 🔄 How It Works

<div align="center">
  
![How It Works](https://via.placeholder.com/800x250?text=How+Indus+Appstore+GitHub+Action+Works)

</div>

1. **Setup**: Add the action to your workflow
2. **Configuration**: Provide required parameters
3. **Execution**: The action builds (optional) and deploys your app
4. **Verification**: Automatic validation ensures successful submission
5. **Publication**: Your app is published to Indus Appstore

## 📚 Documentation

For full documentation, visit our [GitHub Wiki](https://github.com/indusappstore/appstore-release/wiki).

## 🤝 Support

<table>
  <tr>
    <td>
      <h3>📝 Report Issues</h3>
      <a href="https://github.com/indusappstore/appstore-release/issues">Open an issue</a> for action-related problems
    </td>
    <td>
      <h3>🔧 API Support</h3>
      Contact <a href="mailto:support@indusappstore.com">Indus Appstore support</a> for API issues
    </td>
  </tr>
</table>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ by the [Indus Appstore Team](https://indusappstore.com)

</div>
