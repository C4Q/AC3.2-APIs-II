//
//  FacesterGram_IITests.swift
//  FacesterGram-IITests
//
//  Created by Louis Tur on 6/28/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import XCTest
@testable import FacesterGram_II

class FacesterGram_IITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_UserGender_Enum_Values() {
        XCTAssertNotNil(UserGender.both)
        XCTAssertNotNil(UserGender.male)
        XCTAssertNotNil(UserGender.female)
    }
    
    func test_UserNationality_Enum_Values() {
        XCTAssertNotNil(UserNationality.any)
        XCTAssertNotNil(UserNationality.nl)
        XCTAssertNotNil(UserNationality.tr)
        XCTAssertNotNil(UserNationality.us)
    }
    
    func test_Password_Generation_Length() {
        let expectation = XCTestExpectation(description: "Password should be between 8-16 chars")
        
        APIManager.shared.generatePassword { (password: String?) in
            if password != nil {
                if password!.characters.count <= 16 && password!.characters.count >= 8 {
                    expectation.fulfill()
                }
            }
        }
        
        let waiter = XCTWaiter()
        waiter.delegate = self
        waiter.wait(for: [expectation], timeout: 10)
    }
    
    func test_Password_Generation_Content() {
        let expectation = XCTestExpectation(description: "Password should contain at least 1 upper, lower, number and special")
        
        APIManager.shared.generatePassword { (password: String?) in
            if password != nil {

                let hasUpper = (password!.rangeOfCharacter(from: CharacterSet.uppercaseLetters)) != nil
                let hasNumber = (password!.rangeOfCharacter(from: CharacterSet.decimalDigits)) != nil
                let hasLower = (password!.rangeOfCharacter(from: CharacterSet.lowercaseLetters)) != nil
                let hasSpecial = (password!.rangeOfCharacter(from: CharacterSet.symbols)) != nil
                
                if hasUpper && hasLower && hasNumber && hasSpecial {
                    expectation.fulfill()
                }
                
            }
        }
        
        let waiter = XCTWaiter()
        waiter.delegate = self
        waiter.wait(for: [expectation], timeout: 10)
    }
    
    override func waiter(_ waiter: XCTWaiter, didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]) {
        
        for expectation in unfulfilledExpectations {
            XCTFail("Could not fulfill expectation: \(expectation.description)")
        }
    }
}
