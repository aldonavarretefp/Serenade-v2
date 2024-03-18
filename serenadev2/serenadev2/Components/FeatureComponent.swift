//
//  FeatureComponent.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import SwiftUI

struct FeatureComponent: View {
    var icon: String
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var body: some View {
        HStack(alignment: .center, spacing: 32){
            
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .padding(.leading)
                .frame(maxWidth: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Text(description)
                    .foregroundColor(.callout)
            }
        }
    }
}

#Preview {
    FeatureComponent(icon: "", title: "", description: "")
}
