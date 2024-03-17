//
//  UserViewModelTests.swift
//  serenadev2Tests
//
//  Created by Aldo Yael Navarrete Zamora on 17/03/24.
//

import XCTest
@testable import serenadev2

final class UserViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let vm = UserViewModel()
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    var viewModel: UserViewModel!
    var mockCloudKitUtility: MockCloudKitUtility!
    
    override func setUp() {
        super.setUp()
        mockCloudKitUtility = MockCloudKitUtility()
        viewModel = UserViewModel(cloudKitUtility: mockCloudKitUtility)
    }
    
//    func testFetchUserFromAccountIDSuccess() {
//        let expectedUser = User(name: "Aldo", tagName: "aldo", email: "aldo@gmail.com", streak: 0, profilePicture: "", isActive: true, record: .init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "asd")))
//        
//        mockCloudKitUtility.mockUsers = [expectedUser]
//        
//        let expectation = XCTestExpectation(description: "Fetch user from account ID")
//        
//        viewModel.fetchUserFromAccountID(accountID: "testID") { user in
//            XCTAssertEqual(user, expectedUser)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 5.0)
//    }
    
    func testFetchUserFromAccountIDFailure() {
        mockCloudKitUtility.mockUsers = nil
        
        let expectation = XCTestExpectation(description: "Handle failure in fetching user")
        
        viewModel.fetchUserFromAccountID(accountID: "NOVALIDUSERID") { user in
            XCTAssertNil(user)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Add more tests...
    
    override func tearDown() {
        viewModel = nil
        mockCloudKitUtility = nil
        super.tearDown()
    }
}
