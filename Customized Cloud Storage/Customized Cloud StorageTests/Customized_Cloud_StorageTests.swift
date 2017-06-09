//
//  Customized_Cloud_StorageTests.swift
//  Customized Cloud StorageTests
//
//  Created by MingE on 2017/6/6.
//  Copyright © 2017年 MingE. All rights reserved.
//

import XCTest
@testable import Customized_Cloud_Storage

class UserTests: XCTestCase {
    var user: User? = nil
    
    override func setUp() {
        super.setUp()
        let email = "test@gmail.com"
        let password = "test"
        user = User(email: email, password: password)
    }
    
    override func tearDown() {
        //clean object
        user = nil
        super.tearDown()
    }
    
    func test_login_success() {
        //XCTAssert(false)
        user?.login(){loginStatus in
            XCTAssert(true == loginStatus)
            XCTAssert("592d0fba71957372bb51db62" == self.user?.id)
            XCTAssert("test" == self.user?.name)
        }
    }
    
    func test_login_fail() {
        //XCTAssert(false)
        user?.password = "login_fail"
        
        user?.login(){loginStatus in
            XCTAssert(false == loginStatus)
            XCTAssert(nil == self.user?.id.description)
            XCTAssert(nil == self.user?.name.description)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
