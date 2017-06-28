//
//  FacesterGramTests.swift
//  FacesterGramTests
//
//  Created by Louis Tur on 10/20/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import XCTest
@testable import FacesterGram

class FacesterGramTests: XCTestCase {
    private let apiManagerDataRequestDescription = "Data should be returned from APIManager"
    private let apiManagerDataValidityRequestDescription = "Data returned from APIManager should be able to be converted into User"
    
    private var validUserJSON: [String : AnyObject] = {
        let bundle = Bundle(identifier: "nyc.AccessCode.FacesterGramTests")!
        let resource = bundle.url(forResource: "randomUserTesting", withExtension: "json")!
        let data = try! Data(contentsOf: resource)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
        let results = json["results"] as! [[String: AnyObject]]
        return results.first!
    }()
    
    private var invalidUserJSON: [String : AnyObject] = {
        let bundle = Bundle(identifier: "nyc.AccessCode.FacesterGramTests")!
        let resource = bundle.url(forResource: "randomUserTesting_invalid", withExtension: "json")!
        let data = try! Data(contentsOf: resource)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
        let results = json["results"] as! [[String: AnyObject]]
        return results.first!
    }()
    
    
    // MARK: - Tests
    func test_User_Init() {
        print(self.validUserJSON)
        
        let user = User(firstName: "Randy", lastName: "Test", username: "randy.test", emailAddress: "randy.test@gmail.com", thumbnailURL: "me_on_a_cruise.jpg")
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user.firstName, "Randy")
    }
    
    func test_User_JSON_Init() {
        let user = User(json: validUserJSON)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user.firstName, "veronika")
        XCTAssertEqual(user.username, "silvergoose254")
    }
    
    func test_User_JSON_Failable_Init_Should_Succeed_With_Valid_JSON() {
        let user = User(failableJSON: validUserJSON)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user!.firstName, "veronika")
        XCTAssertEqual(user!.username, "silvergoose254")
    }
    
    func test_User_JSON_Failable_Init_Should_Fail_With_Invalid_JSON() {
        let user = User(failableJSON: invalidUserJSON)
        
        XCTAssertNil(user)
    }
    
    
    // MARK - APIManager Tests
    func test_APIManager_Should_Make_Requests() {
        let expectation = XCTestExpectation(description: apiManagerDataRequestDescription)
        APIManager.shared.getRandomUserData { (data: Data?) in
            if data != nil {
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter()
        waiter.delegate = self
        waiter.wait(for: [expectation], timeout: 10.0)
    }
    
    func test_APIManager_Returns_Expected_Data_From_Request() {
        
        let expectation = XCTestExpectation(description: apiManagerDataValidityRequestDescription)
        var users: [User] = []
        APIManager.shared.getRandomUserData { (data: Data?) in
            if data != nil {
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    let resultsData = jsonData["results"] as! [[String : AnyObject]]
                    for result in resultsData {
                        users.append(User(json: result))
                    }
                    
                    if users.count > 0 {
                        expectation.fulfill()
                    }
                }
                catch {
                    XCTFail("Error in parsing: \(error.localizedDescription)")
                }
                
            }
        }

        let waiter = XCTWaiter()
        waiter.delegate = self
        waiter.wait(for: [expectation], timeout: 10.0)
    }
    
    override func waiter(_ waiter: XCTWaiter, didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]) {
        
        for expectation in unfulfilledExpectations {
            XCTFail("Could not fulfill expectation: \(expectation.description)")
        }
    }
}
