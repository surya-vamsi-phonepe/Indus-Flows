# Contributing to Indus Appstore GitHub Action

Thank you for your interest in contributing to the Indus Appstore GitHub Action! We welcome contributions from the community and appreciate your help in making this action better.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Pull Request Process](#pull-request-process)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Standards

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome newcomers and help them succeed
- **Be collaborative**: Work together constructively
- **Be professional**: Maintain a professional tone in all interactions

## Requests

- Submit an issue if you found a bug, or a have a feature request

## 🚀 Getting Started

### Prerequisites

- Git
- Basic understanding of GitHub Actions
- Shell scripting knowledge (Bash)
- YAML configuration experience
- Android development knowledge (for testing)

## 🛠️ How to Contribute

### Types of Contributions

We welcome various types of contributions:

- 🐛 **Bug Reports**: Help us identify and fix issues
- 💡 **Feature Requests**: Suggest new features or improvements
- 📖 **Documentation**: Improve our documentation
- 🔧 **Code Contributions**: Fix bugs or implement features
- 🎨 **Examples**: Contribute workflow examples

### Areas for Contribution

1. **Shell Scripts** (`scripts/` directory)
   - Core functionality improvements
   - Security enhancements
   - Error handling improvements

2. **Action Configuration** (`action.yml`)
   - New input parameters
   - Output improvements
   - Metadata enhancements

3. **Documentation**
   - Example workflows
   - Troubleshooting guides

### Project Structure

```
├── action.yml                 # Action metadata and configuration
├── scripts/
│   ├── core/                  # Core action logic
│   │   ├── detect-package-name.sh
│   │   ├── prepare-upload.sh
│   │   ├── upload-to-store.sh
│   │   └── validate-inputs.sh
│   ├── keystore/              # Keystore management
│   │   ├── cleanup-keystore.sh
│   │   └── setup-keystore.sh
│   └── utils/                 # Utility functions
│       ├── common.sh
│       ├── keystore.sh
│       └── validation.sh
├── examples/                  # Example workflows
└── docs/                      # Additional documentation
```

### Test Cases to Consider

- ✅ Valid APK deployment
- ✅ Valid AAB deployment with keystore
- ✅ Auto-detection functionality
- ✅ Error handling for invalid files
- ✅ Keystore validation
- ✅ Security cleanup
- ❌ Invalid file paths
- ❌ Missing required parameters
- ❌ Corrupted keystore files

## 📤 Pull Request Process

- Make a Pull request from from dev branch if you want to improve the code

## 📄 License
By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Indus Appstore GitHub Action! 🚀

*This document is living and will be updated as the project evolves.*
