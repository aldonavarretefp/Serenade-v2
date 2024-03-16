//
//  TabButton.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import SwiftUI

struct TabSelection: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    var selectedTab: selectedTab
    
    // MARK: - Body
    var body: some View{
        Text(LocalizedStringKey(selectedTab == .music ? "Music" : "People"))
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background()
            .fontWeight(.semibold)
    }
}

#Preview {
    TabSelection(selectedTab: .people)
    .environment(\.locale, .init(identifier: "en"))
}
