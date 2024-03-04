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
                
            } receiveValue: { [weak self] (returnedUsers: [User]?) in
                let users: [User]? = returnedUsers
                guard let user = users?[0] else { return }
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    //MARK: CRUD Functions
    
    func fetchUserFromAccountID(accountID: CKRecord.ID, completion: @escaping (User?) -> Void) {
        let recordToMatch = CKRecord.Reference(recordID: accountID, action: .none)
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", recordToMatch)
        let recordType = UserRecordKeys.type.rawValue

        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                //completion(nil) // Llamada asincrónica fallida, devolver nil
            } receiveValue: { returnedUsers in
                let users: [User]? = returnedUsers
                guard let userR = users?[0] else {
                    completion(nil) // Llamada asincrónica exitosa pero sin usuarios devueltos
                    return
                }
                completion(userR) // Llamada asincrónica exitosa con usuario devuelto
            }
            .store(in: &cancellables)
    }
    
    func createUser(user: User){
        self.searchUsers(tagname: user.tagName) { returnedUsers in
            guard let returnedUsers = returnedUsers else { return }
            if(returnedUsers.isEmpty){
                return
            } else {
                let recordToMatch = CKRecord.Reference(recordID: self.userID!, action: .none)
                let newUser = User(accountID: recordToMatch, name: user.name, tagName: user.tagName, email: user.email, friends: user.friends, posts: user.posts, streak: user.streak, profilePicture: user.profilePicture, isActive: user.isActive, record: user.record)
                CloudKitUtility.add(item: newUser) { _ in }
            }
        }
    }
    
    func updateUser(updatedUser: User) {
        var copyUser = updatedUser
        guard let newUser = copyUser.update(newUser: updatedUser) else { return }
        
        user = newUser
        
        CloudKitUtility.update(item: newUser) { result in
            switch result {
            case .success(_):
                break;
            case .failure(let error):
                print("Error while updating the user ", error.localizedDescription)
                break;
            }
        }
    }
    
    func deleteUser(){
        user?.isActive = false
        updateUser(updatedUser: user!)
    }
    
    func makeFriends(withId user: User, friendId: CKRecord.ID){
        var updatedUser = user
        
        let referenceToFriend = CKRecord.Reference(recordID: friendId, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        
        let recordToMatch = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: friendId)
        let predicate = NSPredicate(format: "recordID = %@", recordToMatch)
        let recordType: CKRecord.RecordType = UserRecordKeys.type.rawValue
        
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { (returnedUsers: [User]?) in
                guard let returnedUsers = returnedUsers, returnedUsers.count != 0 else {
                    print("Error, didn't bring any friend")
                    return
                }
                var updatedFriend = returnedUsers[0]
                if updatedUser.friends == nil {
                    updatedUser.friends = []
                }
                if updatedFriend.friends == nil {
                    updatedFriend.friends = []
                }
                updatedUser.friends?.append(referenceToFriend)
                updatedFriend.friends?.append(referencetoUser)
                
                updatedUser.record["friends"] = updatedUser.friends
                updatedFriend.record["friends"] = updatedFriend.friends
                
                self.updateUser(updatedUser: updatedUser)
                self.updateUser(updatedUser: updatedFriend)
            }
            .store(in: &cancellables)
    }
    
    func deleteFriend(friend: User){
        guard let friendAccountID = friend.accountID else {return}
        let newUserFriends = user?.friends?.filter({ reference in
            return reference != friendAccountID
        })
        user?.friends = newUserFriends ?? []
        updateUser(updatedUser: user!)
    }
    
    func logOut(){
        self.user = nil
    }
    
    func searchUsers(tagname: String, completion: @escaping ([User]?) -> Void) {
        let predicate = NSPredicate(format: "tagName == %@", tagname)
        let recordType = UserRecordKeys.type.rawValue

        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { returnedUsers in
                let friends: [User]? = returnedUsers
                guard let friendss = friends else {
                    completion(nil)
                    return
                }
                completion(friendss)
            }
            .store(in: &cancellables)
    }
}

