//
//  Agenda.swift
//  Agenda
//
//  Created by Bastien Matthai on 23/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class Agenda: NSObject {
    
    public var agendaID: String
    public var agendaName: String
    public var agendaTheme: String
    var cDate: Date
    var userIDs: [String]
    //    var creator: User
    
    init(agendaID: String, agendaName: String, agendaTheme: String, cDate: Date, userIDs: [String]) {
        self.agendaName = agendaName
        self.agendaID = agendaID
        self.agendaTheme = agendaTheme
        self.cDate = cDate
        self.userIDs = userIDs
    }
}
