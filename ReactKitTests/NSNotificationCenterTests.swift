//
//  NSNotificationCenterTests.swift
//  ReactKitTests
//
//  Created by Yasuhiro Inami on 2014/09/11.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import ReactKit
import XCTest

class NSNotificationCenterTests: _TestCase
{
    func testNotificationCenter()
    {
        let expect = self.expectationWithDescription(__FUNCTION__)
        
        let obj1 = MyObject()
        let obj2 = MyObject()
        
        var signal = Notification.signal("MyNotification", obj1)
        
        // REACT
        (obj2, "notification") <~ signal
        
        // REACT
        ^{ println("[REACT] new value = \($0)") } <~ signal
        
        println("*** Start ***")
        
        XCTAssertNil(obj2.notification, "obj2.notification=nil at start.")
        
        self.perform {
            
            Notification.postSignal("MyNotification", "DUMMY")
            
            XCTAssertNil(obj2.notification, "obj2.notification should not be updated because only obj1's MyNotification can be signalled.")
            
            Notification.postSignal("MyNotification", obj1)
            
            XCTAssertNotNil(obj2.notification, "obj2.notification should be updated.")
            
            expect.fulfill()
            
        }
        
        self.wait()
    }
}

class AsyncNSNotificationCenterTests: NSNotificationCenterTests
{
    override var isAsync: Bool { return true }
}