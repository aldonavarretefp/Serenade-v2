//
//  CustomTabBar.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import SwiftUI

enum Tabs {
    case feed
    case search
    case profile
}

struct CustomTabBar: View {
    
    // MARK: - Environment properties
    // Color scheme of the phone
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @Binding var selectedTab: Tabs
    
    // MARK: - Body
    var body: some View {
        
        // Tab bar
        HStack{
            
            // Tab bar item feed
            TabBarItem(icon: selectedTab == .feed ? "home.filled.accent" : "home.filled", label: "Feed")
                .foregroundStyle(selectedTab == .feed ? Color(UIColor(red: 0.73, green: 0.33, blue: 0.83, alpha: 1.00)) : Color(UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)))
                .onTapGesture {
                    // Switch to home
                    selectedTab = .feed
                }
            
            // Tab bar item search
            TabBarItem(icon: "magnifyingglass", label: "Search")
                .foregroundStyle(selectedTab == .search ? Color(UIColor(red: 0.73, green: 0.33, blue: 0.83, alpha: 1.00)) : Color(UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)))
                .onTapGesture {
                    // Switch to search
                    selectedTab = .search
                }
            
            // Tab bar item profile
            TabBarItem(icon: "person.fill", label: "Profile")
                .foregroundStyle(selectedTab == .profile ? Color(UIColor(red: 0.73, green: 0.33, blue: 0.83, alpha: 1.00)) : Color(UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)))
                .onTapGesture {
                    // switch to profile
                    selectedTab = .profile
                }
        }
        .frame(height: 48)
        .background(colorScheme == .light ? .white : .black)
        .padding(.top, 5)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.feed))
}
