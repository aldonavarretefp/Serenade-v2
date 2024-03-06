//
//  PeopleHistoryManager.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 06/03/24.
//

import Foundation
import SwiftUI
import CloudKit

class PeopleHistoryManager: ObservableObject {
    static let shared = PeopleHistoryManager()
    
    private var history: [String] = UserDefaults.standard.stringArray(forKey: "PeopleHistory") ?? []
    
    @Published var people: User?
    @Published var error: Error?
    @EnvironmentObject var userViewModel: UserViewModel
    
    func addToHistory(_ receivedId: String) {
        // If the user is in the history, remove it
        if let index = history.firstIndex(where: { $0 == receivedId }) {
            history.remove(at: index)
        }
        
        // Add the user at the top of the array
        history.insert(receivedId, at: 0)
        
        // Limit the search history
        if history.count > 25 {
            history.removeLast()
        }
        
        // Save the updated history to UserDefaults
        UserDefaults.standard.set(history, forKey: "PeopleHistory")
    }
    
    func getHistory() async -> [User] {
        var users: [User] = []
        
        for historyId in history {
            userViewModel.fetchUserFromRecord(record: CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: historyId))) { user in
                if let user = user {
                    users.append(user)
                }
            }
        }
        return users
    }
    
    // Removed the user when tapped
    func removeUser(userID: String?) {
        if let index = history.firstIndex(where: { $0 == userID }) {
            history.remove(at: index)
            
            // Save the updated history to UserDefaults
            UserDefaults.standard.set(history, forKey: "PeopleHistory")
        }
    }
}
