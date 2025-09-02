## 📋 Description

**Brief summary of changes:**
<!-- Provide a clear and concise description of what this PR does -->

**Related issue(s):**
<!-- Link to related issues using "Fixes #123" or "Closes #456" -->
- Fixes #
- Related to #

## 🔄 Type of Change

<!-- Mark the appropriate box with an 'x' -->
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📖 Documentation update (changes to documentation only)
- [ ] 🔧 Code refactoring (no functional changes)
- [ ] 🧪 Test improvements (adding or updating tests)
- [ ] 🔒 Security improvement

## 🧪 Testing

**Testing performed:**
<!-- Describe how you tested your changes -->
- [ ] Tested locally with sample files
- [ ] Tested with real GitHub Actions workflow
- [ ] Added unit tests (if applicable)
- [ ] Tested with different file types (APK/AAB/APKS)
- [ ] Tested keystore functionality (if applicable)
- [ ] Verified backward compatibility

**Test scenarios covered:**
- [ ] Valid APK deployment
- [ ] Valid AAB deployment with keystore
- [ ] Auto-detection functionality
- [ ] Error handling for invalid inputs
- [ ] Security cleanup verification
- [ ] Cross-platform compatibility (if applicable)

**Test results:**
<!-- Share key test results or attach logs (remove sensitive data) -->

## 📱 Action Configuration Tested

<details>
<summary>Configuration used for testing (click to expand)</summary>

```yaml
# Share the configuration you used for testing (remove sensitive data)
- name: Test Action
  uses: ./
  with:
    file_path: './test-app.apk'
    file_type: 'apk'
    # ... other parameters
```

</details>

## 🔧 Implementation Details

**Key changes made:**
<!-- List the main changes in bullet points -->
- 
- 
- 

**Files modified:**
<!-- List the files you've changed -->
- `scripts/core/example.sh` - Added new validation logic
- `action.yml` - Added new input parameter
- `README.md` - Updated documentation

**Dependencies added/removed:**
<!-- List any new dependencies or removed ones -->
- Added: [dependency name and reason]
- Removed: [dependency name and reason]

## 📖 Documentation

**Documentation updates included:**
- [ ] Updated README.md
- [ ] Updated inline code comments
- [ ] Added/updated examples
- [ ] Updated CONTRIBUTING.md (if needed)
- [ ] Updated action.yml descriptions

**Additional documentation needed:**
<!-- List any documentation that should be updated after this PR -->
- [ ] N/A
- [ ] [specific documentation needs]

## ✅ Checklist

**Code quality:**
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works

**Licensing:**
- [ ] I have added appropriate license headers to new files
- [ ] My contributions are compatible with the MIT license

## 🔗 Additional Notes

<!-- Any additional information that reviewers should know -->

---

**For Reviewers:**
- Focus areas for review: [specific areas you want reviewed]
- Testing suggestions: [how reviewers can test this]
- Questions for discussion: [any questions you have]
