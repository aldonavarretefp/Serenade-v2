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
    @Published var userID: String?
    @Published var isLoggedIn: Bool
    var cancellables = Set<AnyCancellable>()
    
    init(){
        self.userID = nil
        self.isLoggedIn = false
        self.user = nil
        if let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) {
            
            fetchUserFromAccountID(accountID: userID) { returnedUser in
                guard let user = returnedUser else {
                    print("NO USER FROM DB")
                    return
                }
                print("Fetched User from DB: \(user)")
                self.user = returnedUser
                self.userID = userID
                self.isLoggedIn = true
            }
        } else {
            self.userID = nil
            self.isLoggedIn = false
            self.user = nil
        }
    }
    
    //MARK: iCloud Connection
    /*private func getiCloudStatus() {
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
    }*/
        
    /*private func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }*/
    
    /*private func fetchMainUserIDFromiCloud(){
        CloudKitUtility.discoverUserID()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            
            } receiveValue: { [weak self] returnedID in
                self?.userID = returnedID
                self?.fetchMainUser()
            }
            .store(in: &cancellables)
    }*/
    
    /*private func fetchMainUser(){
        guard let userID = self.userID else {return}
        
        let recordToMatch = CKRecord.Reference(recordID: userID, action: .none)
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", recordToMatch)
        let recordType = UserRecordKeys.type.rawValue
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] (returnedUsers: [User]?) in
                let users: [User]? = returnedUsers
//                guard let user = users?[0] else { return }
                let user = User(accountID: nil, name: "Aldo Navarrete", tagName: "aldo", email: "aldo@gmail.com", friends: nil, posts: nil, streak: 10, profilePicture: "", isActive: true, record: .init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "87E3D069-576C-4DF4-A297-C5A15D231511")))
                print(user)
                self?.user = user
            }
            .store(in: &cancellables)
    }
    */
    
    //MARK: CRUD Functions
    
    func fetchUserFromAccountID(accountID: String, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", accountID)
        let recordType = UserRecordKeys.type.rawValue

        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                //completion(nil) // Llamada asincrónica fallida, devolver nil
            } receiveValue: { (returnedUsers: [User]?) in
                
                guard let returnedUsers, returnedUsers.count > 0 else {
                    completion(nil)
                    return
                }
                let user = returnedUsers[0]
                completion(user)
            }
            .store(in: &cancellables)
    }
    
    func fetchUserFromRecord(record: CKRecord, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "recordID == %@", record.recordID)
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
            if(!returnedUsers.isEmpty){
                return
            } else {
                guard let newUser = User(accountID: user.accountID ?? "", name: user.name, tagName: user.tagName, email: user.email, friends: user.friends, posts: user.posts, streak: user.streak, profilePicture: user.profilePicture, isActive: user.isActive) else { return }
                
                CloudKitUtility.add(item: newUser) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.user = newUser
                            self.userID = newUser.accountID
                            self.isLoggedIn = true
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    func updateUser(updatedUser: User) {
            var copyUser = updatedUser
            guard let newUser = copyUser.update(newUser: updatedUser) else { return }
            
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
    
    func unmakeFriends(withId user: User, friendId: CKRecord.ID) {
        var updatedUser = user
        
        // Prepare the references to remove
        let referenceToFriend = CKRecord.Reference(recordID: friendId, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        
        // Fetch the friend user's record
        let predicate = NSPredicate(format: "recordID == %@", friendId)
        let recordType: CKRecord.RecordType = UserRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished fetching friend user")
                case .failure(let error):
                    print("Error fetching friend user: \(error)")
                }
            } receiveValue: { [weak self] (returnedUsers: [User]) in
                guard let self = self, let updatedFriend = returnedUsers.first else {
                    print("Error: Didn't find the friend user")
                    return
                }
                
                // Remove the friend references from each user's friends list
                
                
                var updatedFriendVar = updatedFriend
                var updatedUserVar = updatedUser
                updatedFriendVar.friends?.removeAll(where: { $0 == referencetoUser })
                updatedUserVar.friends?.removeAll(where: { $0 == referenceToFriend })
                // Update the CKRecord for each user
                updatedUserVar.record["friends"] = updatedUser.friends
                updatedFriendVar.record["friends"] = updatedFriend.friends
                
                // Update both user records in CloudKit
                self.updateUser(updatedUser: updatedUserVar)
                self.updateUser(updatedUser: updatedFriendVar)
            }
            .store(in: &cancellables)
    }


    func fetchUser(recordID: CKRecord.ID, completion: @escaping (User?) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                guard let record = record, error == nil else {
                    print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                let user = User(record: record)
                completion(user)
            }
        }
    }

    
    /*func deleteFriend(friend: User){
        guard let friendAccountID = friend.accountID else {return}
        let newUserFriends = user?.friends?.filter({ reference in
            return reference != friendAccountID
        })
        user?.friends = newUserFriends ?? []
        updateUser(updatedUser: user!)
    }*/
    
    func logOut() {
        DispatchQueue.main.async {
            self.user = nil
            self.isLoggedIn = false
            self.userID = nil
        }
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

