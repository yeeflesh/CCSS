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
        user?.login(){ loginStatus in
            XCTAssert(true == loginStatus)
            XCTAssert("592d0fba71957372bb51db62" == self.user?.id)
            XCTAssert("test" == self.user?.name)
        }
    }
    
    func test_login_fail() {
        //XCTAssert(false)
        
        //set wrong password
        user?.password = "login_fail"

        user?.login(){ loginStatus in
            //print("login_fail_loginStatus: \(loginStatus.description)")
            XCTAssert(false == loginStatus)
            XCTAssert(nil == self.user?.id.description)
            XCTAssert(nil == self.user?.name.description)
        }
    }
    
    func test_register_success(){
        //XCTAssert(false)
        
        //set different email
        let emailNum = 4
        let email = "register\(emailNum)@gmail.com"
        user = User(name: "registerTest", email: email, password: "registerTest")
        
        user?.register(){ registerStatus in
            //print("registerStatus_fail_registerStatus: \(registerStatusStatus.description)")
            XCTAssert(true == registerStatus)
        }
    }
    
    func test_register_fail(){
        //XCTAssert(false)
        
        //set wrong password
        user?.name = "test"
        
        user?.register(){ registerStatus in
            //print("register_fail_registerStatusStatus: \(registerStatusStatus.description)")
            XCTAssert(false == registerStatus)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
