//
//  TabBarItem.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import SwiftUI

struct TabBarItem: View {
    
    // MARK: - Properties
    var icon: String
    var label: String
    
    // MARK: - Body
    var body: some View {
        // Geometry reader to fill all the content
        GeometryReader{ geo in
            VStack(spacing: icon != "home.filled" && icon != "home.filled.accent" ? 4 : 0){
                
                // Icon of the tab bar item
                if icon != "home.filled" && icon != "home.filled.accent" {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width:  20, height: 20)
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width:  26, height: 26)
                }
                
                // Label of the tab bar item
                Text(label)
                    .font(.caption2)
            }
            .padding(.horizontal, 20)
            .background()
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .fontWeight(.medium)
    }
}

#Preview {
    TabBarItem(icon: "home.fill", label: "Feed")
}
