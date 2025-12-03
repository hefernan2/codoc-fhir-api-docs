#!/bin/bash
# ╭──────────────────────────────────────────────────────────────────────────────╮
# │  Codoc FHIR IG - Full Build Script                                            │
# │  Downloads IG Publisher and generates full HTML                               │
# ╰──────────────────────────────────────────────────────────────────────────────╯

set -e

echo "🏥 Codoc FHIR Implementation Guide - Full Build"
echo "================================================"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check for Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 17 or higher."
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 or higher is required. Current version: $JAVA_VERSION"
    exit 1
fi

# Download IG Publisher if not present
PUBLISHER_JAR="./input-cache/publisher.jar"
if [ ! -f "$PUBLISHER_JAR" ]; then
    echo ""
    echo "📥 Downloading IG Publisher..."
    mkdir -p ./input-cache
    curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o "$PUBLISHER_JAR"
fi

# Run SUSHI first
echo ""
echo "📦 Running SUSHI..."
if command -v sushi &> /dev/null; then
    sushi .
else
    echo "⚠️  SUSHI not found, skipping FSH compilation"
fi

# Run IG Publisher
echo ""
echo "🔧 Running IG Publisher..."
java -jar "$PUBLISHER_JAR" -ig ig.ini

echo ""
echo "✅ Build complete!"
echo ""
echo "📂 Output is in: output/"
echo "🌐 Open output/index.html to view the IG"
