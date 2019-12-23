//
//  AgendaTests.swift
//  AgendaTests
//
//  Created by Bastien Matthai on 23/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import XCTest

class AgendaManagerTests: XCTestCase {
    
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
    
    func testCreateAgenda() {
        var agendaNameTest: String
        var success = true

        for i in 1...10 {
            agendaNameTest = "defaultAgenda" + String(i)
            let bool1 = (AgendaManager.shared.agendas.filter {
                $0.agendaName == agendaNameTest
            }.count != 0)

            AgendaManager.shared.createAgenda(userID: "User0", agendaName: agendaNameTest, agendaTheme: "default")
            AgendaManager.shared.getAgendaList()

            let bool2 = (AgendaManager.shared.agendas.filter {
                $0.agendaName == agendaNameTest
            }.count == 1)

            if (bool2 == false) {
                success = false
            }
        }

        XCTAssertTrue(success, "Test de création passé avec succès")
    }
    
    func testEditAgenda() {
        
    }
    
    func testDeleteAgenda() {
//        DispatchQueue.main.async {
//            let agendaNameTest = "defaultAgenda001"
//            
//            let bool1 = (AgendaManager.shared.agendas.filter {
//                $0.agendaName == agendaNameTest
//            }.count == 0)
//            
//            if (bool1 == true) {
//                AgendaManager.shared.createAgenda(agendaName: agendaNameTest, agendaTheme: "default")
//            }
//            
//            let bool2 = (AgendaManager.shared.agendas.filter {
//                $0.agendaName == agendaNameTest
//            }.count == 1)
//            
//            if (bool2 == true) {
//                AgendaManager.shared.deleteAgenda(agendaID: agendaNameTest)
//            }
//            
//            let bool3 = (AgendaManager.shared.agendas.filter {
//                $0.agendaName == agendaNameTest
//            }.count == 0)
//            
//            XCTAssertTrue(bool3, "Test suppression passé avec succès")
//        }
    }
    
    func testgetAgendaWithName() {
        
    }
    
    func testgetAgendas() {
        //AgendaManager.shared.getAgenda(agendaID: "defaultAgenda")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
