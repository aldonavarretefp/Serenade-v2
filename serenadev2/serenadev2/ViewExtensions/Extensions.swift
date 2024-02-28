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

// MARK: - Custom View estensions
extension View{
    
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

// MARK: - Offset helper
struct OffsetHelper: ViewModifier{
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
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

// MARK: - Bounds preference key for identifying heigth of the header view
struct HeaderBoundsKey: PreferenceKey{
    static var devaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
