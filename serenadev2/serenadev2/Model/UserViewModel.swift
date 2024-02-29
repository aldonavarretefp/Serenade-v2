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
        fetchMainUserIDFromiCloud()
    }
    
    //MARK: iCloud Connection
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
    
    private func fetchMainUserIDFromiCloud(){
        CloudKitUtility.discoverUserID()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            
            } receiveValue: { [weak self] returnedID in
                self?.userID = returnedID
                self?.fetchMainUser()
            }
            .store(in: &cancellables)
    }
    
    private func fetchMainUser(){
        guard let userID = self.userID else {return}
        let recordToMatch = CKRecord.Reference(recordID: userID, action: .none)
        
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", recordToMatch)
        
        let recordType = UserRecordKeys.type.rawValue
        
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
    
    //MARK: CRUD Functions
    
    func fetchUserFromAccountID(accountID: CKRecord.ID) -> User?{
        guard let userID = self.userID else {return nil}
        let recordToMatch = CKRecord.Reference(recordID: userID, action: .none)
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", recordToMatch)
        let recordType = UserRecordKeys.type.rawValue
        print(recordType)
        var user: User? = nil
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { returnedUsers in
                let users: [User]? = returnedUsers
                guard let userR = users?[0] else { return }
                user = userR
            }
            .store(in: &cancellables)
        return user
    }
    
    func createUser(user: User){
        let recordToMatch = CKRecord.Reference(recordID: userID!, action: .none)
        let newUser = User(accountID: recordToMatch, name: user.name, tagName: user.tagName, email: user.email, friends: user.friends, posts: user.posts, streak: user.streak, profilePicture: user.profilePicture, isActive: user.isActive)
        CloudKitUtility.add(item: newUser) { _ in }
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
    
    func logOut(){
        self.user = nil
    }
    
    func searchFriends(tagname: String) -> [User]? {
        var friends: [User]? = nil
        let predicate = NSPredicate(format: "tagname == %@", tagname)
        let recordType = UserRecordKeys.type.rawValue

        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { returnedUsers in
                friends = returnedUsers
            }
            .store(in: &cancellables)
        
        return friends
    }
    
    // TODO
    func sendFriendRequest(){
        
    }
    
    func cancelFriendRequest(){
        
    }
}

