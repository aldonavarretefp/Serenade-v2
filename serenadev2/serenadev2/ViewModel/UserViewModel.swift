import Foundation
import CloudKit
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var userID: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var tagNameExists: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    init(){
        let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? ""
        print("UserID: ", userID)
        if userID != "" {
            fetchUserFromAccountID(accountID: userID) { returnedUser in
                guard let user = returnedUser else {
                    print("NO USER FROM DB")
                    return
                }
                print("Fetched User from DB: \(user)")
                self.user = returnedUser
                self.userID = userID
                self.isLoggedIn = true
                self.tagNameExists = user.tagName != ""
            }
        }
        
    }
    
    func handleAuthorization(userID: String, fullName: String, email: String) {
        UserDefaults.standard.setValue(userID, forKey: UserDefaultsKeys.userID)
        fetchUserFromAccountID(accountID: userID) { returnedUser in
            guard let user = returnedUser else {
                // User does not exists
                //                let user = User(name: fullName, tagName: "", email: email, streak: 0, profilePicture: "", isActive: true, record: .init(recordType: UserRecordKeys.type.rawValue))
                guard let user = User(accountID: userID, name: fullName, tagName: "", email: email, posts: .init(), streak: 0, profilePicture: "", isActive: true) else {
                    return
                }
                self.createUser(user: user)
                return
            }
            
            // User exists
            print("Fetched User from DB: \(user)")
            DispatchQueue.main.async {
                self.user = returnedUser
                self.userID = userID
                self.isLoggedIn = true
                self.tagNameExists = user.tagName != ""
            }
            
        }
    }
    
    //MARK: CRUD Functions
    func fetchUserFromAccountID(accountID: String, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "accountID == %@ && isActive == 1", accountID)
        let recordType = UserRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
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
        let predicate = NSPredicate(format: "recordID == %@ && isActive == 1", record.recordID)
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
                guard let newUser = User(accountID: user.accountID, name: user.name, tagName: user.tagName, email: user.email, friends: user.friends, posts: user.posts, streak: user.streak, profilePicture: user.profilePicture, isActive: user.isActive) else { return }
                
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
                if(updatedUser.accountID == self.user?.accountID){
                    DispatchQueue.main.async {
                        self.user = newUser
                    }
                }
                print("User updated")
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
    
    func makeFriend(withID friendId: CKRecord.ID){
        guard var updatedUser = user else { return }
        
        let referenceToFriend = CKRecord.Reference(recordID: friendId, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: updatedUser.record.recordID, action: .none)
        
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
                
                updatedUser.friends.append(referenceToFriend)
                updatedFriend.friends.append(referencetoUser)
                
                self.updateUser(updatedUser: updatedUser)
                self.updateUser(updatedUser: updatedFriend)
            }
            .store(in: &cancellables)
    }
    
    func makeFriend(friend: User){
        guard var updatedUser = user else { return }
        var updatedFriend = friend
        
        let referenceToFriend =  CKRecord.Reference(recordID: friend.record.recordID, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: updatedUser.record.recordID, action: .none)
        
        updatedUser.friends.append(referenceToFriend)
        updatedFriend.friends.append(referencetoUser)
        
        updateUser(updatedUser: updatedUser)
        updateUser(updatedUser: updatedFriend)
    }
    
    func unmakeFriend(withID friendId: CKRecord.ID) {
        guard var updatedUser = user else { return }
        
        // Prepare the references to remove
        let referenceToFriend = CKRecord.Reference(recordID: friendId, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: updatedUser.record.recordID, action: .none)
        
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
            } receiveValue: { (returnedUsers: [User]?) in
                guard let returnedUsers = returnedUsers, returnedUsers.count != 0 else {
                    print("Error, didn't bring any friend")
                    return
                }
                
                var updatedFriend = returnedUsers[0]
                
                // Remove the friend references from each user's friends list
                updatedFriend.friends.removeAll(where: { $0 == referencetoUser })
                updatedUser.friends.removeAll(where: { $0 == referenceToFriend })
                
                // Update both user records in CloudKit
                self.updateUser(updatedUser: updatedUser)
                self.updateUser(updatedUser: updatedFriend)
            }
            .store(in: &cancellables)
    }
    
    func unmakeFriend(friend: User) {
        guard var updatedUser = user else { return }
        var updatedFriend = friend
        
        // Prepare the references to remove
        let referenceToFriend = CKRecord.Reference(recordID: friend.record.recordID, action: .none)
        let referencetoUser = CKRecord.Reference(recordID: updatedUser.record.recordID, action: .none)
        
        
        updatedFriend.friends.removeAll(where: { $0 == referencetoUser })
        updatedUser.friends.removeAll(where: { $0 == referenceToFriend })
        
        // Update both user records in CloudKit
        updateUser(updatedUser: updatedUser)
        updateUser(updatedUser: updatedFriend)
    }
    
    func logOut() {
        
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)
        
        
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
    
    func addPostToUser(sender: User, post: Post) {
        var newUser = sender
        newUser.posts = newUser.posts ?? []
        newUser.posts?.append(CKRecord.Reference(recordID: post.record.recordID, action: .none))
        updateUser(updatedUser: newUser)
    }
    
    func isFriend(of friend: User) -> Bool{
        if let user = self.user {
            let friendIDs = user.friends.map { $0.recordID }
            return friendIDs.contains(friend.record.recordID)
        } else {
            return false
        }
    }
}
