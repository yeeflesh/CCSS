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
        let currentUser = self.user
        currentUser?.login(){ loginStatus in
            XCTAssertEqual(true, loginStatus)
            XCTAssertEqual("592d0fba71957372bb51db62", currentUser?.id)
            XCTAssertEqual("test", currentUser?.name)
        }
    }
    
    func test_login_fail() {
        //XCTAssert(false)
        
        //set wrong password
        user?.password = "login_fail"

        user?.login(){ loginStatus in
            //print("login_fail_loginStatus: \(loginStatus.description)")
            XCTAssertEqual(false, loginStatus)
            XCTAssertEqual(nil, self.user?.id.description)
            XCTAssertEqual(nil, self.user?.name.description)
        }
    }
    
    func test_register_success(){
        //XCTAssert(false)
        
        //set different email
        let emailNum = 4
        let email = "register\(emailNum)@gmail.com"
        user = User(name: "registerTest", email: email, password: "test")
        
        user?.register(){ registerStatus in
            //print("registerStatus_fail_registerStatus: \(registerStatusStatus.description)")
            XCTAssertEqual(true, registerStatus)
        }
    }
    
    func test_register_fail(){
        //XCTAssert(false)
        
        //set exsist account
        user?.name = "test"
        
        user?.register(){ registerStatus in
            //print("register_fail_registerStatusStatus: \(registerStatusStatus.description)")
            XCTAssertEqual(false, registerStatus)
        }
    }
    
    func test_getClientServerList_success(){
        //login first
        let currentUser = user
        currentUser?.login(){loginStatus in
            currentUser?.getClientServerList(){ getClientServerListStatus in
                //print("register_fail_registerStatusStatus: \(registerStatusStatus.description)")
                XCTAssertEqual(true, getClientServerListStatus)
                
                let clientServer = currentUser?.clientServerList[0]
                XCTAssertEqual("86c84a1f-e36e-42d3-b944-982e6db83872", clientServer?.id)
                XCTAssertEqual("edit_server_name", clientServer?.name)
                XCTAssertEqual("140.124.181.196", clientServer?.host)
                XCTAssertEqual("1e71fd45-37ff-4e82-b1dd-b208ed3876a3", clientServer?.token)
            }
        }
    }
    
    func test_getClientServerList_timeOut(){
        //XCTAssert(false)
        let currentUser = User(email: "timeOutTest@gmail.com", password: "test")
        //login first
        currentUser.login(){loginStatus in
            //print("user id: \(user.id), email: \(user.email), loginStatus: \(loginStatus)")
            currentUser.getClientServerList(){ getClientServerListStatus in
                //print("register_fail_registerStatusStatus: \(registerStatusStatus.description)")
                XCTAssertEqual(false, getClientServerListStatus)
                
//                let clientServer = self.user?.clientServerList[0]
//                XCTAssert("86c84a1f-e36e-42d3-b944-982e6db83872" == clientServer?.id)
//                XCTAssert("edit_server_name" == clientServer?.name)
//                XCTAssert("140.124.181.196" == clientServer?.host)
//                XCTAssert("1e71fd45-37ff-4e82-b1dd-b208ed3876a3" == clientServer?.token)
            }
        }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
