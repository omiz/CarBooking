//
//  BookingTests.swift
//  CarBookingTests
//
//  Created by Omar Allaham on 10/22/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import XCTest

class BookingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGet() {
        DataManager.shared.bookings.all().load {
            assert($0?.array.isEmpty ?? true, "")
        }
    }
    
    func testPost() {
        
        let exp = expectation(description: "testPost")
//        let semaphore = DispatchSemaphore(value: 0)
        
        let booking = Booking()
        
        DataManager.shared.bookings.book(booking).load {
            
            assert($0 != nil, "Post object is nil")
            
            exp.fulfill()
            
//            self.checkAvailablilty(booking, found: {
//                assert(booking == $0, "differnet object returned from post")
//                exp.fulfill()
//            })
        }
        
        waitForExpectations(timeout: 10) {
            guard $0 == nil else { return assertionFailure($0?.localizedDescription ?? "Timeout") }
            
        }
    }
    
    func checkAvailablilty(_ booking: Booking, found: @escaping ((Booking) -> Void)) {
        
        DataManager.shared.bookings.all().load(database: {
            guard let array = $0?.array else { return assertionFailure("Array after post is empty") }
            
            guard let founded = array.first(where: { $0 == booking })
                else { return assertionFailure("Posted object was not saved") }
            
            found(founded)
        })
    }
    
    func testPut() {
        let booking = Booking()
        
        DataManager.shared.bookings.book(booking).load {
            assert($0 != nil, "")
        }
    }
    
    func testDelete() {
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
