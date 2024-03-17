//
//  NotificationsView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//


import SwiftUI
import CloudKit

struct NotificationsView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var friendRequestViewModel: FriendRequestsViewModel
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                // Background of the view
                Color.viewBackground
                    .ignoresSafeArea()
                
                // Scroll to show all the notifications
                ScrollView {
                    VStack(spacing: 35) {

                        if loadingStateViewModel.isLoadingNotifications {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .font(.title2)
                        } else {
                            ForEach(friendRequestViewModel.friendRequests, id: \.id ){ request  in
                                if let user = friendRequestViewModel.userDetails[request.sender.recordID] {
                                    NotificationItem(user: user, friendRequest: request, isDisabled: $loadingStateViewModel.isLoadingHandleFriendship)
                                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                                }
                            }
                            
                        }
                    }
                    .padding()
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationTitle(LocalizedStringKey("Notifications"))
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                self.updateNotifications()
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
        }
    }

    func updateNotifications() {
        loadingStateViewModel.isLoadingNotifications = true
        withAnimation(.easeInOut(duration: 1.0).delay(1.0) ) {
            if let currentUser = userViewModel.user {
                print(friendRequestViewModel.friendRequests.count)
                self.friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser) {
                    print(friendRequestViewModel.friendRequests.count)
                    loadingStateViewModel.isLoadingNotifications = false
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
