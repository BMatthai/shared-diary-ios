////
////  Event.swift
////  Agenda
////
////  Created by Bastien Matthai on 23/09/2019.
////  Copyright © 2019 Bastien MATTHAI. All rights reserved.
////

import UIKit

class Event: NSObject {

    var eventID: String
    var agendaID: String
    var eventName: String
    var placeName: String
    var cDate: Date
    var beginDate: Date
    var endDate: Date
    var participantIDs: [String]

    init(agendaID: String,placeName: String, eventID: String, eventName: String, cDate: Date, beginDate: Date, endDate: Date, participantIDs: [String]) {
        self.eventID = eventID
        self.placeName = placeName
        self.agendaID = agendaID
        self.cDate = cDate
        self.beginDate = beginDate
        self.endDate = endDate
        self.eventName = eventName
        self.participantIDs = participantIDs
    }
}
