#!/bin/bash
# OpenSCAD MCP Release Cleanup Script
# This script prepares the project for release by removing development artifacts
# while preserving essential files for a clean, professional package

set -e  # Exit on error

echo "🧹 OpenSCAD MCP Release Cleanup Script"
echo "======================================"
echo "This will remove development artifacts while preserving:"
echo "  ✅ Core source code (src/)"
echo "  ✅ Test suite (tests/)"
echo "  ✅ Documentation"
echo "  ✅ Configuration files"
echo ""

# Safety check
read -p "⚠️  This will permanently delete files. Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

echo ""
echo "📋 Starting cleanup process..."
echo ""

# Phase 1: Remove Python virtual environment
echo "1️⃣  Removing Python virtual environment..."
if [ -d "openscad-mcp-server/test-env/" ]; then
    rm -rf openscad-mcp-server/test-env/
    echo "   ✅ Removed test-env/"
else
    echo "   ⏭️  test-env/ not found, skipping"
fi

# Phase 2: Clean root directory test artifacts
echo ""
echo "2️⃣  Cleaning test artifacts from root directory..."
echo "   NOTE: Preserving organized tests/ directory for coverage"

# Remove test scripts from root
for file in test_*.py test_*.sh; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "   ✅ Removed $file"
    fi
done

# Remove test output files
for pattern in "*test*.json" "*test*.txt"; do
    for file in $pattern; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "   ✅ Removed $file"
        fi
    done
done

# Remove .scad files from root
for file in *.scad; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "   ✅ Removed $file"
    fi
done

# Remove generated images
for file in *.png; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "   ✅ Removed $file"
    fi
done

# Phase 3: Clean redundant documentation
echo ""
echo "3️⃣  Removing redundant documentation..."
for pattern in "openscad_mcp_*.md" "*_REPORT.md" "*_FIX*.md" "CLAUDE_MCP_*.md" "MCP_INTEGRATION_*.md"; do
    for file in $pattern; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "   ✅ Removed $file"
        fi
    done
done

# Phase 4: Clean openscad-mcp-server root directory
echo ""
echo "4️⃣  Cleaning openscad-mcp-server/ root (preserving tests/ directory)..."
cd openscad-mcp-server/ 2>/dev/null || true

if [ -d "." ]; then
    # Remove test files from root only (not from tests/ subdirectory)
    for file in comprehensive_test.py integration_test.py simple_test.py test_*.py verify_imports.py; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "   ✅ Removed $file"
        fi
    done
    
    # Remove test output files
    for pattern in "*test*.txt" "*_output.txt"; do
        for file in $pattern; do
            if [ -f "$file" ] && [ "$file" != "tests/"* ]; then
                rm -f "$file"
                echo "   ✅ Removed $file"
            fi
        done
    done
    
    # Remove sample .scad files
    for file in part_*.scad; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "   ✅ Removed $file"
        fi
    done
    
    # Remove report and fix documentation
    for pattern in "*_REPORT.md" "*_FIX*.md"; do
        for file in $pattern; do
            if [ -f "$file" ]; then
                rm -f "$file"
                echo "   ✅ Removed $file"
            fi
        done
    done
    
    cd ..
else
    echo "   ⏭️  openscad-mcp-server/ not found, skipping"
fi

# Phase 5: Remove misc artifacts
echo ""
echo "5️⃣  Removing miscellaneous artifacts..."
if [ -d ".openscad-mcp/" ]; then
    rm -rf .openscad-mcp/
    echo "   ✅ Removed .openscad-mcp/"
fi

# Clean Python cache files
echo "   Cleaning Python cache files..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type f -name "*.pyo" -delete 2>/dev/null || true
echo "   ✅ Cleaned Python cache files"

# Phase 6: Verify essential structure
echo ""
echo "6️⃣  Verifying essential files are preserved..."
essential_preserved=true

# Check core directories
for dir in "openscad-mcp-server/src" "openscad-mcp-server/tests" "openscad-mcp-server/.github"; do
    if [ -d "$dir" ]; then
        echo "   ✅ $dir preserved"
    else
        echo "   ❌ WARNING: $dir not found!"
        essential_preserved=false
    fi
done

# Check essential files
for file in "openscad-mcp-server/pyproject.toml" "openscad-mcp-server/README.md" "openscad-mcp-server/LICENSE"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file preserved"
    else
        echo "   ❌ WARNING: $file not found!"
        essential_preserved=false
    fi
done

echo ""
echo "========================================"
if [ "$essential_preserved" = true ]; then
    echo "✅ Cleanup complete! All essential files preserved."
else
    echo "⚠️  Cleanup complete with warnings. Please check missing files."
fi

echo ""
echo "📊 Summary:"
echo "  • Virtual environment removed"
echo "  • Test artifacts cleaned (tests/ directory preserved)"
echo "  • Redundant documentation removed"
echo "  • Sample files cleaned"
echo "  • Python cache cleared"
echo ""
echo "📋 Next steps:"
echo "  1. Review the structure with: tree openscad-mcp-server/ -I '__pycache__|*.pyc'"
echo "  2. Consider moving rendering_tools/ to examples/ if keeping"
echo "  3. Update repository URLs in pyproject.toml"
echo "  4. Run tests to ensure functionality: cd openscad-mcp-server && pytest"
echo "  5. Build package: cd openscad-mcp-server && python -m build"
echo ""
echo "🚀 Ready for release preparation!"