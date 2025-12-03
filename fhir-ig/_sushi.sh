#!/bin/bash
# ╭──────────────────────────────────────────────────────────────────────────────╮
# │  Codoc FHIR IG Build Script                                                   │
# │  Compiles FSH to FHIR resources using SUSHI                                   │
# ╰──────────────────────────────────────────────────────────────────────────────╯

set -e

echo "🏥 Codoc FHIR Implementation Guide Build"
echo "========================================="

# Check if SUSHI is installed
if ! command -v sushi &> /dev/null; then
    echo "❌ SUSHI is not installed. Install it with:"
    echo "   npm install -g fsh-sushi"
    exit 1
fi

# Navigate to the IG directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "📦 Running SUSHI compiler..."
echo ""

sushi .

echo ""
echo "✅ SUSHI compilation complete!"
echo ""
echo "Generated artifacts are in: fsh-generated/"
echo ""
echo "Next steps:"
echo "  1. To generate the full IG HTML, run: ./_genonce.sh"
echo "  2. Or use the IG Publisher directly"
