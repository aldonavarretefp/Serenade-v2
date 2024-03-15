//
//  pushNotificationManager.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 07/03/24.
//

import SwiftUI
import CloudKit

class PushNotificationViewModel: ObservableObject {
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure.")
            }
        }
    }
    
    //The user that sends a friend request gets a notification when it's accepted
    func suscribeToFriendRequestAccepted(me: User, friend: User){
        let recordToMatchSender = CKRecord.Reference(record: me.record, action: .none)
        let recordToMatchReceiver = CKRecord.Reference(record: friend.record, action: .none)
        let predicate = NSPredicate(format: "sender == %@ && receiver == %@ && status == %@", recordToMatchSender, recordToMatchReceiver,FriendRequestStatus.accepted.rawValue)
        let subscription = CKQuerySubscription(recordType: FriendRequestsRecordKeys.type.rawValue, predicate: predicate, subscriptionID: "friend_request_accepted", options: .firesOnRecordUpdate)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "\(friend.tagName) has accepted your friend request"
        notification.alertBody = "Open the app to see your friend's profile"
        notification.soundName = "default"
        notification.shouldBadge = true
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications! \(friend.tagName)")
            }
        }
    }
    
    //The user that recieves a friend request gets a notification with the name of the user that has send the friend request
    func suscribeToFriendRequestRecieved(user: User?){
        guard let user = user else { return }
        let recordToMatch = CKRecord.Reference(record: user.record, action: .none)
        let predicate = NSPredicate(format: "receiver == %@ && status == %@", recordToMatch, FriendRequestStatus.pending.rawValue)
        
        let subscription = CKQuerySubscription(recordType: FriendRequestsRecordKeys.type.rawValue, predicate: predicate, subscriptionID: "new_friend_request", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "You have a new friend request!"
        notification.soundName = "default"
        notification.shouldBadge = true

        // Customizing the alert body to include the name of the sender
        notification.alertLocalizationArgs = ["senderName"]
        notification.alertLocalizationKey = "%1$@ sent you a friend request. Open the app to accept."
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }

    func unsubscribeToNotifications() {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "new_friend_request") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
    
}
