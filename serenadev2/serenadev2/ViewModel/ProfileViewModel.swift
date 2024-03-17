//
//  ProfileViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import Foundation
import CloudKit

final class ProfileViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var user: User = User(name: "No User", tagName: "nouser", email: "", streak: 0, profilePicture: "", isActive: false, record: CKRecord(recordType: UserRecordKeys.type.rawValue))
    
    @Published var friendsFromUser : [User] = []
    @Published var isFriend: Bool = false
    @Published var isFriendRequestSent: Bool = false
    @Published var isFriendRequestReceived: Bool = false
    @Published var showFriendRequestButton: Bool = false
    
    // Variables to hide/show the header
    @Published var headerHeight: CGFloat = 0
    @Published var headerOffset: CGFloat = 0
    @Published var lastHeaderOffset: CGFloat = 0
    @Published var direction: SwipeDirection = .none
    @Published var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @Published var headerOpacity: Double = 1.0
    
    
    func adjustOffsets(previous: CGFloat, current: CGFloat) -> Void {
        
        // Moving header based on direction scroll
        if previous > current{
            // MARK: - Up
            if direction != .up && current < 0{
                shiftOffset = current - headerOffset
                direction = .up
                lastHeaderOffset = headerOffset
            }
            
            let offset = current < 0 ? (current - shiftOffset) : 0
            
            // Checking if it does not goes over header height
            headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
            
            // get the normalized offset so it is always between 0 and 1
            let normalizedOffset = 100
            
            // Calculate the opaciti for the header and the button
            headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
            
        } else {
            // MARK: - Down
            if direction != .down{
                shiftOffset = current
                direction = .down
                lastHeaderOffset = headerOffset
            }
            
            let offset = lastHeaderOffset + (current - shiftOffset)
            headerOffset = (offset > 0 ? 0 : offset)
            
            // get the normalized offset so it is always between 0 and 1
            let normalizedOffset = 100
            
            // Calculate the opaciti for the header and the button
            headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
            
        }
        
    }
    
}
