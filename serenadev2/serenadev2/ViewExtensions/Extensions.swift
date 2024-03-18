//
//  Extensions.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import Foundation
import SwiftUI

// MARK: - Custom Color extensions
extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
    
    func adjustedForContrast(with color: Color = .white) -> Color {
        // Get the lightness component of the color
        let luminance = self.luminance(color: color)
        
        // Define a contrast threshold
        let contrastThreshold: Double = 10 // You can adjust this threshold
        
        // Compare the luminosity component with the contrast threshold
        if luminance > contrastThreshold {
            // If the contrast is good, return the original color
            return self
        } else {
            // If the contrast is not good, adjust the color to a darker tone
            return self.darkened()
        }
    }
    
    func luminance(color: Color = .white) -> Double {
        // Convert Color to UIColor to access its components
        let uiColor = UIColor(color)
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Calculate the luminosity component according to the luminosity formula
        return Double(0.299 * r + 0.587 * g + 0.114 * b)
    }
    
    func darkened() -> Color {
        // Darken the color by reducing its brightness component
        return Color(UIColor(self).adjusted(by: -0.2))
    }
}

// MARK: - Custom UIColor extensions
extension UIColor {
    func adjusted(by percentage: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract the HSB components of the color
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Adjust the brightness by the given percentage
        brightness += percentage
        brightness = max(min(brightness, 1.0), 0.0) // Ensure it is within the range 0-1
        
        // Create and return the new adjusted color
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

// MARK: - Custom View extensions
extension View {
    
    // MARK: - Preview, current offset to find the direction of swipe
    @ViewBuilder
    func offsetY(completion: @escaping (CGFloat, CGFloat) -> ()) -> some View{
        self
            .modifier(OffsetHelper(onChange: completion))
    }
    
    // MARK: - Safe area
    func safeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return .zero}
        guard let safeArea = scene.windows.first?.safeAreaInsets else {return .zero}
        return safeArea
    }
}

// MARK: - Custom String extensions
extension String {
    var formattedForTagName: String {
        self.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var containsEmoji: Bool { contains { $0.isEmoji } }
}

extension Color {
    
  init(hex: String) {
    let trimHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    let dropHash = String(trimHex.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
    let hexString = trimHex.starts(with: "#") ? dropHash : trimHex
    let ui64 = UInt64(hexString, radix: 16)
    let value = ui64 != nil ? Int(ui64!) : 0
    // #RRGGBB
    var components = (
        R: CGFloat((value >> 16) & 0xff) / 255,
        G: CGFloat((value >> 08) & 0xff) / 255,
        B: CGFloat((value >> 00) & 0xff) / 255,
        a: CGFloat(1)
    )
    if String(hexString).count == 8 {
        // #RRGGBBAA
        components = (
            R: CGFloat((value >> 24) & 0xff) / 255,
            G: CGFloat((value >> 16) & 0xff) / 255,
            B: CGFloat((value >> 08) & 0xff) / 255,
            a: CGFloat((value >> 00) & 0xff) / 255
        )
    }
    self.init(red: components.R, green: components.G, blue: components.B)
}

func toHex(alpha: Bool = false) -> String? {
    guard let components = cgColor?.components, components.count >= 3 else {
        return nil
    }
    
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
        a = Float(components[3])
    }
    
    if alpha {
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
}

// MARK: - Offset helper
struct OffsetHelper: ViewModifier {
    var onChange: (CGFloat, CGFloat) -> ()
    
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay{
                GeometryReader{ proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self){ value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset, currentOffset)
                        }
                }
            }
    }
}

// MARK: - Offset key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

// MARK: - Bounds preference key for identifying heigth of the header view
struct HeaderBoundsKey: PreferenceKey {
    static var devaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}


public struct ShimmerConfiguration {
    
    public let gradient: Gradient
    public let initialLocation: (start: UnitPoint, end: UnitPoint)
    public let finalLocation: (start: UnitPoint, end: UnitPoint)
    public let duration: TimeInterval
    public let opacity: Double
    public static let `default` = ShimmerConfiguration(
        gradient: Gradient(stops: [
            .init(color: .black.opacity(0.2), location: 0),
            .init(color: .white.opacity(0.2), location: 0.3),
            .init(color: .white.opacity(0.2), location: 0.7),
            .init(color: .black.opacity(0.2), location: 1),
        ]),
        initialLocation: (start: UnitPoint(x: -1, y: 0.5), end: .leading),
        finalLocation: (start: .trailing, end: UnitPoint(x: 2, y: 0.5)),
        duration: 2,
        opacity: 0.6
    )
}

struct ShimmeringView<Content: View>: View {
    private let content: () -> Content
    private let configuration: ShimmerConfiguration
    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint
    init(configuration: ShimmerConfiguration, @ViewBuilder content: @escaping () -> Content) {
        self.configuration = configuration
        self.content = content
        _startPoint = .init(wrappedValue: configuration.initialLocation.start)
        _endPoint = .init(wrappedValue: configuration.initialLocation.end)
    }
    var body: some View {
        ZStack {
            content()
            LinearGradient(
                gradient: configuration.gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .opacity(configuration.opacity)
            .blendMode(.screen)
            .onAppear {
                withAnimation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false)) {
                    startPoint = configuration.finalLocation.start
                    endPoint = configuration.finalLocation.end
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

public struct ShimmerModifier: ViewModifier {
    let configuration: ShimmerConfiguration
    public func body(content: Content) -> some View {
        ShimmeringView(configuration: configuration) { content }
    }
}


public extension View {
    func shimmer(configuration: ShimmerConfiguration = .default) -> some View {
        modifier(ShimmerModifier(configuration: configuration))
    }
}

// Extension to UIScreen to get screen dimensions
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

//function to get the final trimmed caption
extension View{
    func sanitizeText(_ text: String) -> String {
        // Esto reemplazará los saltos de línea con puntos
        let replacedText = text.replacingOccurrences(of: "\\n+", with: " ", options: .regularExpression)
        
        return replacedText
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
