#!/bin/bash

# Integrate SVG Icon Script
# This script integrates your KeepAwake.svg icon into the app

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"
ORIGINAL_SVG="/Users/ahmadfaridabbas/Desktop/KeepAwake/KeepAwake.svg"

echo "🎨 Integrating your custom KeepAwake SVG icon..."

# Check if the original SVG exists
if [ ! -f "$ORIGINAL_SVG" ]; then
    echo "❌ SVG icon not found at: $ORIGINAL_SVG"
    echo "Please make sure the file exists and try again."
    exit 1
fi

echo "✅ Found your SVG icon: $ORIGINAL_SVG"

# Create directories
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"
SVG_ICON_DIR="$ASSETS_DIR/KeepAwakeIcon.imageset"

mkdir -p "$APPICON_DIR"
mkdir -p "$MENUBAR_ICON_DIR"
mkdir -p "$SVG_ICON_DIR"

# For SVG icons, we'll convert to PNG for compatibility
# Check if we have conversion tools available
if command -v rsvg-convert &> /dev/null; then
    CONVERTER="rsvg-convert"
    echo "✅ Using rsvg-convert for SVG conversion"
elif command -v inkscape &> /dev/null; then
    CONVERTER="inkscape"
    echo "✅ Using Inkscape for SVG conversion"
elif command -v qlmanage &> /dev/null; then
    CONVERTER="qlmanage"
    echo "✅ Using qlmanage for SVG conversion"
else
    echo "⚠️  No SVG converter found. Installing librsvg..."
    # Try to install librsvg via Homebrew
    if command -v brew &> /dev/null; then
        brew install librsvg 2>/dev/null || echo "Please install librsvg manually"
        CONVERTER="rsvg-convert"
    else
        echo "❌ Please install Homebrew or librsvg to convert SVG files"
        echo "   Alternative: Convert your SVG to PNG manually and use the PNG version"
        exit 1
    fi
fi

# Function to convert SVG to PNG
convert_svg() {
    local input="$1"
    local output="$2"
    local size="$3"
    
    if [ "$CONVERTER" = "rsvg-convert" ]; then
        rsvg-convert -w "$size" -h "$size" "$input" -o "$output" 2>/dev/null
    elif [ "$CONVERTER" = "inkscape" ]; then
        inkscape --export-width="$size" --export-height="$size" --export-filename="$output" "$input" 2>/dev/null
    elif [ "$CONVERTER" = "qlmanage" ]; then
        # qlmanage is more complex, let's use a different approach
        sips -s format png -Z "$size" "$input" --out "$output" 2>/dev/null || {
            echo "⚠️  qlmanage conversion failed, trying alternative..."
            # Copy SVG and let Xcode handle it
            cp "$input" "${output%.png}.svg"
        }
    fi
}

echo "🔄 Converting SVG to PNG at all required sizes..."

# App Icon sizes for macOS
echo "📱 Creating app icons from SVG..."
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_16x16.png" 16
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_16x16@2x.png" 32
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_32x32.png" 32
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_32x32@2x.png" 64
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_128x128.png" 128
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_128x128@2x.png" 256
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_256x256.png" 256
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_256x256@2x.png" 512
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_512x512.png" 512
convert_svg "$ORIGINAL_SVG" "$APPICON_DIR/icon_512x512@2x.png" 1024

echo "✅ Created 10 app icon sizes from SVG"

# Menu Bar Icon sizes
echo "📋 Creating menu bar icons from SVG..."
convert_svg "$ORIGINAL_SVG" "$MENUBAR_ICON_DIR/menubar_icon.png" 18
convert_svg "$ORIGINAL_SVG" "$MENUBAR_ICON_DIR/menubar_icon@2x.png" 36
convert_svg "$ORIGINAL_SVG" "$MENUBAR_ICON_DIR/menubar_icon@3x.png" 54

echo "✅ Created 3 menu bar icon sizes from SVG"

# Also create a direct SVG asset for potential future use
echo "📄 Creating SVG asset..."
cp "$ORIGINAL_SVG" "$SVG_ICON_DIR/keepawake_icon.svg"

# Create Contents.json for SVG asset
cat > "$SVG_ICON_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "keepawake_icon.svg",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  },
  "properties" : {
    "template-rendering-intent" : "template"
  }
}
EOF

echo "✅ Created SVG asset for future use"

echo ""
echo "🎉 SVG icon integration complete!"
echo ""
echo "📁 Generated files:"
echo "• App Icons: $APPICON_DIR (10 PNG files from SVG)"
echo "• Menu Bar Icons: $MENUBAR_ICON_DIR (3 PNG files from SVG)"
echo "• SVG Asset: $SVG_ICON_DIR (original SVG preserved)"
echo ""
echo "✨ Benefits of using SVG:"
echo "• Perfect scaling at all sizes"
echo "• Crisp appearance on all displays"
echo "• Small file size"
echo "• Vector-based precision"
echo ""
echo "🔧 Next step: Your app code is already configured to use the custom icon!"

# Verify the conversions worked
echo ""
echo "🔍 Verifying conversions..."
app_icons_created=$(find "$APPICON_DIR" -name "*.png" 2>/dev/null | wc -l)
menubar_icons_created=$(find "$MENUBAR_ICON_DIR" -name "*.png" 2>/dev/null | wc -l)

echo "📊 Conversion results:"
echo "• App icons created: $app_icons_created/10"
echo "• Menu bar icons created: $menubar_icons_created/3"

if [ "$app_icons_created" -eq 10 ] && [ "$menubar_icons_created" -eq 3 ]; then
    echo "✅ All icons successfully converted from SVG!"
else
    echo "⚠️  Some conversions may have failed. Check the files manually."
fi
