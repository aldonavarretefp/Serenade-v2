//
//  Extensions.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import Foundation
import SwiftUI


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
    
    func adjustedForContrast() -> Color {
        // Obtener el componente de luminosidad del color
        let luminance = self.luminance()
        
        // Definir un umbral de contraste
        let contrastThreshold: CGFloat = 10.0
        
        // Comparar el componente de luminosidad con el umbral de contraste
        if luminance > contrastThreshold {
            // Si el contraste es bueno, devolver el color original
            return self
        } else {
            // Si el contraste no es bueno, ajustar el color hacia un tono más oscuro
            return self.darkened()
        }
    }
    
    func luminance() -> CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Calcular el componente de luminosidad según la fórmula de luminosidad
        return 0.299 * r + 0.587 * g + 0.114 * b
    }
    
    func darkened() -> Color {
        // Oscurecer el color al reducir su componente de brillo
        return Color(UIColor(self).adjusted(by: -0.2))
    }
}

extension UIColor {
    func adjusted(by percentage: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extraer los componentes HSB del color
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Ajustar el brillo por el porcentaje dado
        brightness += percentage
        brightness = max(min(brightness, 1.0), 0.0) // Asegurar que esté dentro del rango 0-1
        
        // Crear y devolver el nuevo color ajustado
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
