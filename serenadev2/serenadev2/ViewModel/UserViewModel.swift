import Foundation
import CloudKit
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var userID: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var tagNameExists: Bool = false
    @Published var error: String = ""
    @Published var friends : [User] = []
    @Published var finishedTheProfile: Bool = false
    @Published var hasPostedHisDaily: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    init(){
        let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? ""
        print("UserID: ", userID)
        if userID != "" {
            fetchUserFromAccountID(accountID: userID) { returnedUser in
                guard let user = returnedUser else {
                    print("NO USER FROM DB")
                    self.error = "No user fetch"
                    return
                }
                print("Fetched User from DB: \(user)")
                DispatchQueue.main.async {
                    self.user = returnedUser
                    self.userID = userID
                    self.isLoggedIn = true
                    self.tagNameExists = user.tagName != userID.lowercased()
                }
            }
            
            
        }
        
    }
    
    func handleAuthorization(userID: String, fullName: String, email: String) {
        
        UserDefaults.standard.setValue(userID, forKey: UserDefaultsKeys.userID)
        
        fetchUserFromAccountID(accountID: userID) { returnedUser in
            guard let user = returnedUser else {
                guard let user = User(accountID: userID, name: fullName, tagName: userID.lowercased(), email: email, posts: .init(), streak: 0, profilePicture: "", isActive: true, profilePictureAsset: nil) else {
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
                self.tagNameExists = user.tagName != userID.lowercased()
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
    
    func fetchUserFromRecordID(recordID: CKRecord.ID, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "recordID == %@ && isActive == 1", recordID)
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
    
    
    
    func fetchUserFromRecordReference(recordReference: CKRecord.Reference, completion: @escaping (User?) -> Void) {
        // Extract the CKRecord.ID from the reference
        let recordID = recordReference.recordID
        
        // The rest of your code remains the same, now using the extracted recordID
        let predicate = NSPredicate(format: "recordID == %@ && isActive == 1", recordID)
        let recordType = UserRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // Handle completion if needed
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

    func fetchUserFromRecordIDAsync(recordID: CKRecord.ID) async -> User? {
        await withCheckedContinuation { continuation in
            fetchUserFromRecordID(recordID: recordID) { user in
                continuation.resume(returning: user)
            }
        }
    }

    func fetchFriendsForUser(user: User) async -> [User] {
        var friendsFromUser: [User] = []

        for friendReference in user.friends {
            if let friend = await fetchUserFromRecordIDAsync(recordID: friendReference.recordID) {
                friendsFromUser.append(friend)
                print("This is the friend added:", friend)
            }
        }

        return friendsFromUser
    }

    
    func createUser(user: User){
        if(user.tagName == "") { return }
        guard let newUser = User(accountID: user.accountID, name: user.name, tagName: user.tagName, email: user.email, friends: user.friends, posts: user.posts, streak: user.streak, profilePicture: user.profilePicture, isActive: user.isActive, profilePictureAsset: nil) else {
            self.error.append(" No se pudo crear un nuevo usuario en createUser")
            return
        }
        
        CloudKitUtility.add(item: newUser) { result in
            switch result {
            case .success(_):
                //self.error.append(" Se pudo agregar al usuario")
                DispatchQueue.main.async {
                    self.user = newUser
                    self.userID = newUser.accountID
                    self.isLoggedIn = true
                    self.makeFriend(withID: CKRecord.ID.init(recordName: "AB32E1CA-F299-4124-8D11-807EE922974E"))
                }
                break
            case .failure(_):
                DispatchQueue.main.async {
                    self.error = "Couldnt be created"
                }
                break
            }
        }
        
    }
    
    func updateUser(updatedUser: User, completionHandler: (() -> ())? = nil) {   
        if(updatedUser.tagName == "" || updatedUser.name == "") {
            return
        }
        var copyUser = updatedUser
        guard let newUser = copyUser.update(newUser: updatedUser) else { return }
        CloudKitUtility.update(item: newUser) { result in
            switch result {
            case .success(_):
                
                if let user = self.user, updatedUser.accountID == user.accountID {
                    DispatchQueue.main.async {
                        self.user = newUser
                    }
                }
                
                print("\(newUser.name) updated")
                
                break;
            case .failure(let error):
                print("Error while updating the user ", error.localizedDescription)
                break;
            }
        }
    }
    
    func deleteUser(){
        guard var user else {
            return
        }
        user.isActive = false
        updateUser(updatedUser: user)
    }
    
    func makeFriend(withID friendId: CKRecord.ID) {
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
    
    func searchUsers(searchText: String, completion: @escaping ([User]?) -> Void) {
        let predicate = NSPredicate(format: "isActive == 1")
        let recordType = UserRecordKeys.type.rawValue
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // Handle any subscription-related responses here, if necessary.
            } receiveValue: { [weak self] (returnedUsers: [User]?) in
                guard let self = self, let users = returnedUsers else {
                    completion(nil)
                    return
                }
                
                // Perform local filtering based on searchText
                let filteredUsers = users.filter { user in
                    return user.tagName.lowercased().contains(searchText.lowercased()) || user.name.lowercased().contains(searchText.lowercased())
                }
                
                completion(filteredUsers)
            }
            .store(in: &self.cancellables)
    }

    
    func searchFriendsFromUser(){
        
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
