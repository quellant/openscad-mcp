# 📋 OpenSCAD MCP Release Cleanup Plan

## 🎯 Objective
Prepare the OpenSCAD MCP project for release by removing unnecessary files, consolidating documentation, and ensuring a clean, professional package structure with the minimal set of files needed for good libraries, DevOps, and documentation.

## 📊 Current State Analysis
- **Project Type**: Python MCP (Model Context Protocol) Server for OpenSCAD
- **Main Package**: `openscad-mcp-server/`
- **Critical Issues**: 
  - Python virtual environment included (test-env/)
  - Multiple test files scattered in root
  - Redundant documentation files
  - Sample .scad files mixed with source
  - Test output artifacts

---

## 🗑️ PHASE 1: DELETE - Immediate Removal (High Priority)

### Virtual Environment & Dependencies
```bash
# Remove the entire Python virtual environment
rm -rf openscad-mcp-server/test-env/
```

### Test Files in Root Directory (DELETE - These are development artifacts)
```bash
# Remove test scripts and outputs from PROJECT ROOT ONLY
# These are ad-hoc test files, not the organized test suite
rm -f test_*.py
rm -f test_*.sh
rm -f test_*.scad
rm -f mcp_test_results.json
rm -f test_results.json
rm -f test_output.txt
rm -f test_final_output.txt
rm -f mcp_tool_test_results.json
rm -f mcp_tools_test_output.txt
rm -f test_claude_mcp_integration.sh
rm -f test_claude_with_permissions.sh
rm -f test_mcp_direct.py
```

### Test Files in openscad-mcp-server/ Root (DELETE - These are development artifacts)
```bash
cd openscad-mcp-server/
# Remove ad-hoc test files from package root
# The proper test suite is preserved in tests/ directory
rm -f comprehensive_test.py
rm -f comprehensive_test_output.txt
rm -f integration_test.py
rm -f simple_test.py
rm -f test_*.py  # Only removes files in root, not in tests/ subdirectory
rm -f verify_imports.py
rm -f import_test_output.txt
rm -f server_startup_test.txt
```

### ⚠️ IMPORTANT: Test Suite to PRESERVE
```bash
# The following organized test structure MUST BE KEPT:
# openscad-mcp-server/tests/
#   ├── __init__.py               # Package initialization
#   ├── conftest.py              # Pytest fixtures
#   ├── pytest.ini               # Pytest configuration
#   ├── test_documentation.md    # Test documentation
#   ├── test_edge_cases.py       # Edge case tests
#   ├── test_openscad_mcp.py     # Main test suite
#   ├── test_performance.py      # Performance tests
#   └── unit/                    # Unit tests
#       ├── __init__.py
#       └── test_config.py

# These files are essential for test coverage and CI/CD
```

### Sample/Example .scad Files
```bash
# Remove sample .scad files from root
rm -f *.scad

# Remove sample .scad files from openscad-mcp-server
cd openscad-mcp-server/
rm -f part_*.scad
```

### Generated Images & Artifacts
```bash
# Remove generated images from root
rm -f *.png

# Remove any cached or temporary directories
rm -rf .openscad-mcp/
rm -rf __pycache__/
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
```

### Redundant Documentation
```bash
# Remove development/internal documentation from root
rm -f openscad_mcp_*.md
rm -f openscad_rendering_analysis.md
rm -f openscad_response_optimization_final.md
rm -f MCP_INTEGRATION_TEST_REPORT.md
rm -f CLAUDE_MCP_PERMISSIONS.md

# Remove fix/report documents from openscad-mcp-server/
cd openscad-mcp-server/
rm -f *_FIX*.md
rm -f *_REPORT*.md
rm -f openscad_mcp_test_report.md
rm -f CAMERA_PARAMETER_FIX.md
```

---

## ✅ PHASE 2: KEEP - Essential Files for Release

### Root Directory Structure
```
mech-mcp/
├── openscad-mcp-server/        # Main package directory
└── [Optional directories - see recommendations below]
```

### ⚠️ DECISION REQUIRED: Additional Directories

**rendering_tools/** - Contains Python rendering utilities:
- Option 1: DELETE if not essential for MCP server functionality
- Option 2: MOVE to `openscad-mcp-server/examples/rendering/` if valuable for users
- Option 3: CREATE separate package `openscad-rendering-tools` if independently useful

**MCP Configuration Files** (mcp.json, mcp_config.json):
- Review if these are example configurations or required for server operation
- If examples: Move to `openscad-mcp-server/examples/config/`
- If required: Move to `openscad-mcp-server/` root or document their placement

### openscad-mcp-server/ Essential Files
```
openscad-mcp-server/
├── .github/                    # GitHub Actions workflows
├── src/                        # Source code
│   └── openscad_mcp/
│       ├── core/              # Core functionality
│       ├── resources/         # MCP resources
│       ├── tools/             # MCP tools
│       └── utils/             # Utilities
├── tests/                      # Organized test directory (PRESERVE)
├── pyproject.toml             # Python package configuration
├── LICENSE                    # License file
├── README.md                  # Main documentation
├── CHANGELOG.md               # Version history
├── CONTRIBUTING.md            # Contribution guidelines
├── API.md                     # API documentation
├── DEPLOYMENT.md              # Deployment instructions
├── requirements-test.txt      # Test dependencies
├── pytest.ini                 # Pytest configuration
├── .coveragerc               # Coverage configuration
├── .gitignore                # Git ignore rules
├── .dockerignore             # Docker ignore rules
├── .env.example              # Environment variables example
├── Dockerfile                # Container definition
└── MANIFEST.in               # Package manifest
```

---

## 🔄 PHASE 3: RESTRUCTURE - Organization Improvements

### 1. Create Examples Directory
```bash
cd openscad-mcp-server/
mkdir -p examples/

# Move any essential example files here
# Create a simple example demonstrating usage
cat > examples/basic_usage.py << 'EOF'
"""Basic usage example for OpenSCAD MCP Server"""
# Add example code here
EOF
```

### 2. Consolidate Documentation
```bash
cd openscad-mcp-server/

# Create docs directory if needed for additional documentation
mkdir -p docs/

# Move any detailed documentation to docs/
# Keep only essential docs in root:
# - README.md (user-facing)
# - CHANGELOG.md (version history)
# - CONTRIBUTING.md (contributor guide)
# - LICENSE (legal requirement)
# - API.md (API reference)
```

### 3. Verify Test Structure (Already Organized)
```bash
cd openscad-mcp-server/

# The tests/ directory is already properly organized with:
# - Unit tests, edge cases, performance tests
# - Pytest configuration (conftest.py, pytest.ini)
# - Test documentation

# Additional subdirectories can be created if needed:
mkdir -p tests/integration/  # If not already present
mkdir -p tests/fixtures/      # For test data/fixtures

# Ensure all test directories have __init__.py
touch tests/integration/__init__.py 2>/dev/null || true
```

---

## 📝 PHASE 4: FINAL CHECKLIST

### Documentation Quality
- [ ] README.md includes:
  - [ ] Clear installation instructions
  - [ ] Quick start guide
  - [ ] Basic usage examples
  - [ ] Link to full documentation
  - [ ] Badge for CI/CD status
  - [ ] License badge

- [ ] CHANGELOG.md is up to date with latest version
- [ ] API.md documents all public endpoints/tools
- [ ] DEPLOYMENT.md includes production deployment steps
- [ ] CONTRIBUTING.md has clear contribution guidelines

### Package Configuration
- [ ] pyproject.toml has correct:
  - [ ] Package name and version
  - [ ] Dependencies listed
  - [ ] Entry points defined
  - [ ] Author and license information
  - [ ] Python version requirements

- [ ] MANIFEST.in includes all necessary non-Python files
- [ ] .gitignore excludes all development artifacts
- [ ] LICENSE file is present and correct

### Code Quality
- [ ] All source files < 500 lines
- [ ] No hardcoded secrets or credentials
- [ ] Environment variables used for configuration
- [ ] Proper error handling throughout
- [ ] Logging implemented appropriately

### DevOps Ready
- [ ] Dockerfile builds successfully
- [ ] .github/workflows has CI/CD pipelines
- [ ] Tests can be run with simple command
- [ ] Coverage reporting configured
- [ ] Security scanning in place

---

## 🚀 PHASE 5: RELEASE VERIFICATION

### Pre-Release Commands
```bash
# Clean build artifacts
cd openscad-mcp-server/
rm -rf build/ dist/ *.egg-info/

# Verify package structure
python -m build --sdist --wheel

# Test installation in clean environment
python -m venv test-release-env
source test-release-env/bin/activate  # or test-release-env\Scripts\activate on Windows
pip install dist/*.whl

# Run basic import test
python -c "import openscad_mcp; print('Import successful')"

# Clean up test environment
deactivate
rm -rf test-release-env/
```

### Final Structure Should Be:
```
mech-mcp/
├── openscad-mcp-server/
│   ├── src/openscad_mcp/     # Core package code
│   ├── tests/                # Organized tests
│   ├── examples/             # Usage examples
│   ├── docs/                 # Additional documentation (if needed)
│   ├── .github/              # CI/CD workflows
│   ├── pyproject.toml        # Package configuration
│   ├── README.md             # Main documentation
│   ├── CHANGELOG.md          # Version history
│   ├── LICENSE               # License
│   ├── API.md                # API documentation
│   ├── CONTRIBUTING.md       # Contribution guide
│   ├── DEPLOYMENT.md         # Deployment guide
│   └── [config files]        # .gitignore, Dockerfile, etc.
└── rendering_tools/          # If essential to the project
```

---

## 📊 Expected Impact

### Before Cleanup:
- Numerous test files scattered
- Virtual environment included (~200MB+)
- Redundant documentation files
- Mixed sample files
- Unclear project structure

### After Cleanup:
- Clean, professional structure
- Only essential files included
- Clear separation of concerns
- Ready for PyPI publication
- Reduced package size by ~95%
- Professional appearance for open-source release

---

## ⚡ Quick Execution Script

Save this as `cleanup_for_release.sh`:

```bash
#!/bin/bash
set -e

echo "🧹 Starting OpenSCAD MCP Release Cleanup..."

# Phase 1: Remove test environment
echo "Removing Python virtual environment..."
rm -rf openscad-mcp-server/test-env/

# Phase 2: Clean test artifacts (NOT the tests/ directory!)
echo "Cleaning test artifacts from root directories..."
echo "NOTE: Preserving tests/ directory for test coverage"
rm -f test_*.py test_*.sh *.scad *.png
rm -f *test*.json *test*.txt
rm -f openscad_mcp_*.md *_REPORT.md *_FIX*.md

# Phase 3: Clean openscad-mcp-server root (NOT tests/ subdirectory)
cd openscad-mcp-server/
# Remove test files from root only, preserving tests/ directory
rm -f ./*test*.py ./*test*.txt part_*.scad
rm -f ./*_REPORT.md ./*_FIX*.md
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
cd ..

# Phase 4: Remove misc artifacts
rm -rf .openscad-mcp/

echo "✅ Cleanup complete! Review remaining structure."
echo "📋 Next: Review KEEP list and run verification steps."
```

Make executable and run:
```bash
chmod +x cleanup_for_release.sh
./cleanup_for_release.sh
```

---

## 🎯 Success Criteria

1. **Minimal File Set**: Only files necessary for functionality, documentation, and development
2. **Clear Structure**: Intuitive organization for new contributors
3. **Professional Appearance**: Ready for public release
4. **Small Package Size**: No unnecessary bloat
5. **Complete Documentation**: Users can understand and use the package
6. **DevOps Ready**: CI/CD pipelines functional
7. **Test Coverage**: Tests organized and runnable

---

## 📅 Timeline

1. **Immediate (5 minutes)**: Run deletion script for obvious removals
2. **Short-term (30 minutes)**: Review and organize remaining files
3. **Final (1 hour)**: Test installation and verify functionality
4. **Release Ready**: Package prepared for PyPI/GitHub release

---

*This plan ensures the OpenSCAD MCP Server is release-ready with a minimal, professional structure suitable for open-source distribution.*