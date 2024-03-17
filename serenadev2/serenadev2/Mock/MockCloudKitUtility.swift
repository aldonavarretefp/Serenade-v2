//
//  MockCloudkitUtility.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 17/03/24.
//

import Foundation

protocol CloudKitUtilityProtocol {
    func fetch(predicate: NSPredicate, recordType: String, completion: @escaping ([User]?) -> Void)
    
}

class MockCloudKitUtility: CloudKitUtilityProtocol {
    var mockUsers: [User]?
    func fetch(predicate: NSPredicate, recordType: String, completion: @escaping ([User]?) -> Void) {
        completion(mockUsers)
    }
    // Implement other methods as needed...
}
