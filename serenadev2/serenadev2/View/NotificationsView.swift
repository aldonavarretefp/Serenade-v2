//
//  NotificationsView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//


import SwiftUI
import CloudKit

struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var friendRequestViewModel: FriendRequestsViewModel
    @State private var isLoadingNotifications: Bool = false
    @State var isLoadingHandleFriendship: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                VStack{
                    ScrollView {
                        VStack(spacing: 35) {

                            if isLoadingNotifications {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .font(.title2)
                            } else {
                                ForEach(friendRequestViewModel.friendRequests, id: \.id ){ request  in
                                    if let user = friendRequestViewModel.userDetails[request.sender.recordID] {
                                        NotificationItem(user: user, friendRequest: request, isDisabled: $isLoadingHandleFriendship)
                                            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                                    }
                                }
                            }
                        }
                        .padding()
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
    }

    func updateNotifications() {
        isLoadingNotifications = true
        withAnimation(.easeInOut(duration: 1.0).delay(1.0) ) {
            if let currentUser = userViewModel.user {
                print(friendRequestViewModel.friendRequests.count)
                self.friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser) {
                    print(friendRequestViewModel.friendRequests.count)
                    isLoadingNotifications = false
                }
            }
        }
        
    }
}

#Preview {
    NotificationsView()
        .environment(\.locale, .init(identifier: "it"))
}
