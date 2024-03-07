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
    
    func subscribeToNotifications(user: User?) {
        guard let user = user else { return }
        let recordToMatch = CKRecord.Reference(record: user.record, action: .none)
        let predicate = NSPredicate(format: "receiver == %@ && status == %@", recordToMatch, FriendRequestStatus.pending.rawValue)

        let subscription = CKQuerySubscription(recordType: FriendRequestsRecordKeys.type.rawValue, predicate: predicate, subscriptionID: "new_friend_request", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "You have a new friend request!"
        notification.alertBody = "Open the app to accept your friend."
        notification.soundName = "default"
        
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
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "new_friend_request") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
    
}
