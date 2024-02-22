//
//  MockedUser.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 22/02/24.
//

import Foundation
import CloudKit

let reference = CKRecord.Reference(record: mockedUser2.record, action: .none)

let mockedUser: User = .init(name: "Sebas", email: "sebatooo@gmail.com", streak: 10, profilePicture: "https://lh3.googleusercontent.com/a/ACg8ocIlKulfr3ErDewen2yMpLEMFn5MuiOn-OjohQZckLjLrrjk=s96-c", isActive: true, tagName: "sebatoo", friendRequestSent: [CKRecord.Reference](), friendRequestReceived: [CKRecord.Reference]())

var mockedUser2: User = .init(name: "Aldo Navarrete", email: "aaldiitoo@gmail.com", streak: 10, profilePicture: "https://lh3.googleusercontent.com/a/ACg8ocIlKulfr3ErDewen2yMpLEMFn5MuiOn-OjohQZckLjLrrjk=s96-c", isActive: true, tagName: "aaldiitoo", friendRequestSent: [CKRecord.Reference](), friendRequestReceived: [CKRecord.Reference]())

