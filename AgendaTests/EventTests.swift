//
//  EventTests.swift
//  AgendaTests
//
//  Created by Bastien Matthai on 23/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import XCTest

class EventTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateEvent() {

        for i in 1...5 {
            for j in 1...5 {
            
                EventManager.shared.createEvent(agendaID: "defaultAgenda" + String(i) + "@User0", placeName: "nulle part", eventName: "defaultEvent" + String(j) + String(i), beginDate: Date(), endDate: Date())
            }
           
        }
    }
    
}
