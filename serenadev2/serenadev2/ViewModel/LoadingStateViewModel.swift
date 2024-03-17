//
//  LoadingStateViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation

final class LoadingStateViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoadingStateOfFriendShip: Bool = false
    @Published var isLoadingNotifications: Bool = false
    @Published var isLoadingHandleFriendship: Bool = false
}
