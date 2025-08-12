#!/bin/bash

# Integrate Custom Icon Script
# This script helps integrate your custom icon into the KeepAwake app

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🎨 Integrating custom icon into KeepAwake..."

# Check if Assets.xcassets exists
ASSETS_DIR="$APP_DIR/Assets.xcassets"

if [ ! -d "$ASSETS_DIR" ]; then
    echo "📁 Creating Assets.xcassets directory..."
    mkdir -p "$ASSETS_DIR"
    echo "✅ Created Assets.xcassets"
else
    echo "✅ Assets.xcassets already exists"
fi

# Create AppIcon.appiconset directory
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"

if [ ! -d "$APPICON_DIR" ]; then
    echo "📁 Creating AppIcon.appiconset directory..."
    mkdir -p "$APPICON_DIR"
    echo "✅ Created AppIcon.appiconset"
else
    echo "✅ AppIcon.appiconset already exists"
fi

# Create Contents.json for AppIcon
echo "📝 Creating AppIcon Contents.json..."

cat > "$APPICON_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ Created AppIcon Contents.json"

# Create MenuBarIcon.imageset directory for menu bar icons
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"

if [ ! -d "$MENUBAR_ICON_DIR" ]; then
    echo "📁 Creating MenuBarIcon.imageset directory..."
    mkdir -p "$MENUBAR_ICON_DIR"
    echo "✅ Created MenuBarIcon.imageset"
fi

# Create Contents.json for MenuBarIcon
echo "📝 Creating MenuBarIcon Contents.json..."

cat > "$MENUBAR_ICON_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "menubar_icon.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "menubar_icon@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "menubar_icon@3x.png",
      "idiom" : "universal",
      "scale" : "3x"
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

echo "✅ Created MenuBarIcon Contents.json"

echo ""
echo "🎯 Icon Integration Setup Complete!"
echo ""
echo "📋 Required Icon Sizes for macOS App:"
echo "App Icon (place in $APPICON_DIR):"
echo "• icon_16x16.png (16×16)"
echo "• icon_16x16@2x.png (32×32)"
echo "• icon_32x32.png (32×32)"
echo "• icon_32x32@2x.png (64×64)"
echo "• icon_128x128.png (128×128)"
echo "• icon_128x128@2x.png (256×256)"
echo "• icon_256x256.png (256×256)"
echo "• icon_256x256@2x.png (512×512)"
echo "• icon_512x512.png (512×512)"
echo "• icon_512x512@2x.png (1024×1024)"
echo ""
echo "Menu Bar Icon (place in $MENUBAR_ICON_DIR):"
echo "• menubar_icon.png (16×16 or 18×18)"
echo "• menubar_icon@2x.png (32×32 or 36×36)"
echo "• menubar_icon@3x.png (48×48 or 54×54)"
echo ""
echo "📝 Next Steps:"
echo "1. Resize your icon to all required sizes"
echo "2. Place the icon files in the appropriate directories"
echo "3. Update the app code to use your custom icons"
echo "4. Build and test your app"
echo ""
echo "💡 Pro Tips:"
echo "• Menu bar icons should be black/white template images"
echo "• App icons should be colorful and detailed"
echo "• Use PNG format with transparency"
echo "• Test icons in both light and dark modes"
