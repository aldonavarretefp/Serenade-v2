//
//  UserViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 22/02/24.
//

import Foundation
import CloudKit
import Combine


class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var permissionStatus: Bool = false
    @Published var userID: CKRecord.ID?
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init(){
        getiCloudStatus()
        requestPermission()
        fetchUserIDFromiCloud()
    }
    
    private func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedInToiCloud = success
            }
            .store(in: &cancellables)
    }
        
    private func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
    
    func createUser(user: User){
        CloudKitUtility.add(item: user) { _ in }
    }
    
    private func fetchUserIDFromiCloud(){
        CloudKitUtility.discoverUserID()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            
            } receiveValue: { [weak self] returnedID in
                self?.userID = returnedID
                self?.fetchUser()
            }
            .store(in: &cancellables)
    }
    
    private func fetchUser(){
        guard let userID = self.userID else {return}
        let recordToMatch = CKRecord.Reference(recordID: userID, action: .none)
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", recordToMatch)
        let recordType = UserRecordKeys.type.rawValue
        print(recordType)
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedUsers in
                let users: [User]? = returnedUsers
                guard let user = users?[0] else { return }
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateUser(newUser: User){
        CloudKitUtility.update(item: newUser) { _ in }
    }
    
    func deleteUser(){
        user?.isActive = false
        updateUser(newUser: user!)
    }
    
    func addFriend(friend: User){
        guard let friendAccountID = friend.accountID else {return}
        user?.friends?.append(friendAccountID)
        updateUser(newUser: user!)
    }
    
    func deleteFriend(friend: User){
        guard let friendAccountID = friend.accountID else {return}
        let newUserFriends = user?.friends?.filter({ reference in
            return reference != friendAccountID
        })
        user?.friends = newUserFriends
        updateUser(newUser: user!)
    }
}
