//
//  HeaderViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import Foundation

// MARK: - Swipe direction
enum SwipeDirection{
    case up
    case down
    case none
}

final class HeaderViewModel: ObservableObject{
    // Variables to hide/show the header
    @Published var headerHeight: CGFloat = 0
    @Published var headerOffset: CGFloat = 0
    @Published var lastHeaderOffset: CGFloat = 0
    @Published var direction: SwipeDirection = .none
    @Published var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @Published var headerOpacity: Double = 1.0
}
