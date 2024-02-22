//
//  UserViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 22/02/24.
//

import Foundation


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
}
