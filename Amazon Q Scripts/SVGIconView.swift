import SwiftUI
import WebKit

// Enhanced SVG Icon Support for KeepAwake
// This provides better SVG rendering in SwiftUI

struct SVGIconView: NSViewRepresentable {
    let svgName: String
    let color: Color
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let svgPath = Bundle.main.path(forResource: svgName, ofType: "svg"),
              let svgContent = try? String(contentsOfFile: svgPath) else {
            return
        }
        
        // Convert SwiftUI Color to CSS color
        let cssColor = color.cssString
        
        // Modify SVG to use the specified color
        let modifiedSVG = svgContent.replacingOccurrences(
            of: "fill=\"[^\"]*\"",
            with: "fill=\"\(cssColor)\"",
            options: .regularExpression
        )
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { margin: 0; padding: 0; background: transparent; }
                svg { width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            \(modifiedSVG)
        </body>
        </html>
        """
        
        nsView.loadHTMLString(html, baseURL: nil)
    }
}

// Color extension to convert SwiftUI Color to CSS
extension Color {
    var cssString: String {
        // This is a simplified conversion - you might want to enhance this
        switch self {
        case .primary: return "currentColor"
        case .green: return "#00FF00"
        case .orange: return "#FF8000"
        case .red: return "#FF0000"
        case .blue: return "#0000FF"
        default: return "currentColor"
        }
    }
}

// Alternative: Simple SVG Icon View using NSImage
struct SimpleIconView: View {
    let iconName: String
    let color: Color
    let size: CGSize
    
    var body: some View {
        if let nsImage = NSImage(named: iconName) {
            Image(nsImage: nsImage)
                .renderingMode(.template)
                .foregroundColor(color)
                .frame(width: size.width, height: size.height)
        } else {
            // Fallback to system icon
            Image(systemName: "moon.fill")
                .foregroundColor(color)
                .frame(width: size.width, height: size.height)
        }
    }
}

// Usage in your KeepAwakeApp.swift:
/*
// Replace the Image view in the MenuBarExtra label with:
SimpleIconView(
    iconName: "MenuBarIcon",
    color: menuBarIconColor,
    size: CGSize(width: 18, height: 18)
)
*/
