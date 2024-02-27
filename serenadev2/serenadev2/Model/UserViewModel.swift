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
    @Published var users: [User] = []
    @Published var permissionStatus: Bool = false
    @Published var userID: CKRecord.ID?
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init(user: User? = nil){
        getiCloudStatus()
        requestPermission()
        fetchUserIDFromiCloud()
        
    }
        
    
    func createUser(user: User){
        CloudKitUtility.add(item: user) { _ in
        }
    }
    
    private func fetchUserIDFromiCloud(){
        CloudKitUtility.discoverUserID()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            
            } receiveValue: { [weak self] returnedID in
                self?.userID = returnedID
                print(returnedID)
                self?.fetchUser()
            }
            .store(in: &cancellables)
    }
    
    private func fetchUser(){
        guard let userID = self.userID else {return}
        print(userID)
        let predicate = NSPredicate(value: true)
        let recordType = UserRecordKeys.type.rawValue
        print(recordType)
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] re in
                self?.users = re
            }
            .store(in: &cancellables)
    }
    
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
        
    func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
}
