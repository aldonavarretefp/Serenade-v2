//
//  UserViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 22/02/24.
//

import Foundation
import CloudKit


class UserViewModel: ObservableObject {
    @Published var user: User?
    
    func saveUser(user: User) async -> Void {
        do {
            try await UserService.createUser(user: user)
            DispatchQueue.main.async {
                self.user = user
            }
        } catch let error {
            print("error", error.localizedDescription)
        }
        
    }
    
    func fetchUserWithId(id: CKRecord.ID) async -> User? {
        do {
            let user = try await UserService.fetchUserWithId(id: id)
            return user
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
