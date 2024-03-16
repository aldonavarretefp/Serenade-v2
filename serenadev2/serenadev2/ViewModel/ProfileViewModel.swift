//
//  ProfileViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import Foundation
import CloudKit

final class ProfileViewModel: ObservableObject{
    
    @Published var user: User = User(name: "No User", tagName: "nouser", email: "", streak: 0, profilePicture: "", isActive: false, record: CKRecord(recordType: UserRecordKeys.type.rawValue))
    
    @Published var friendsFromUser : [User] = []
    @Published var isFriend: Bool = false
    @Published var isFriendRequestSent: Bool = false
    @Published var isFriendRequestReceived: Bool = false
    @Published var showFriendRequestButton: Bool = false
}
