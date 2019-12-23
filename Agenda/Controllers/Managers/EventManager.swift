//
//  EventAPI.swift
//  Event
//
//  Created by Bastien Matthai on 24/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit
import Firebase

class EventManager: NSObject, AgendaObserver, UserObserver {
    
    static let shared = EventManager()
    var events = [Event]()
    var selectedEventID: String = ""
    var eventObservers = [EventObserver]()
    
    private override init() {
        super.init()
        AgendaManager.shared.attachObserver(agendaObserver: self)
        UserManager.shared.attachObserver(userObserver: self)
    }
    
    func attachObserver(eventObserver: EventObserver) {
        eventObservers.append(eventObserver)
    }
    
    func detachEventObservers() {
        eventObservers.removeAll()
    }
    
    private func notify() {
        for observer in eventObservers {
            observer.updateEventObservers()
        }
    }
    
    func updateAgendaObservers() {
        getEventList()
    }
    
    func updateUserObservers() {
        getEventList()
    }
    
    func createEvent(agendaID: String, placeName: String, eventName: String, beginDate: Date, endDate: Date) {
        let db = FirebaseManager.shared.fireStore()
        let cDate = Timestamp()
        let beginDate = Timestamp(date: beginDate)
        let endDate = Timestamp(date: endDate)
        let curUserID = UserManager.shared.currentUser()?.uid
        
        var ref: DocumentReference? = nil
        ref = db.collection("events").addDocument(data: [
            "agendaID" : agendaID,
            "name": eventName,
            "place": placeName,
            "cdate": cDate,
            "beginDate": beginDate,
            "endDate": endDate,
            "participantids": [curUserID]
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func getEventList() {
        let db = FirebaseManager.shared.fireStore()
        let uid = UserManager.shared.currentUser()?.uid
        let agendaIDs = AgendaManager.shared.agendas.map({$0.agendaID})
        
        db.collection("events").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
            } else {
                self.events.removeAll()
                for document in querySnapshot!.documents {
                    
                    let eventID = document.documentID
                    let agendaID = document["agendaID"] as! String
                    let eventName = document["name"] as! String
                    let placeName = document["place"] as! String
                    let cDate = (document["cdate"] as! Timestamp).dateValue()
                    let beginDate = (document["beginDate"] as! Timestamp).dateValue()
                    let endDate = (document["endDate"] as! Timestamp).dateValue()
                    let participantIDs = document["participantids"] as! [String]
                    
                    self.events.append(Event(agendaID: agendaID,placeName: placeName, eventID: eventID, eventName: eventName, cDate: cDate, beginDate: beginDate, endDate: endDate, participantIDs: participantIDs))
                    print(" Event: \(eventID)")
                }
            }
            self.events = self.events.filter {agendaIDs.contains($0.agendaID)}.sorted(by: { $0.beginDate < $1.beginDate })
            self.notify()
        }
    }
    
    func addParticipantInEvent(event: Event, userID: String) {
        let db = FirebaseManager.shared.fireStore()
        let eventRef = db.collection("events").document(event.eventID)
        
        eventRef.updateData([
            "participantids": FieldValue.arrayUnion([userID])
        ]){ err in
            if let err = err {
            } else {
                if (event.participantIDs.contains(userID)) {
                    return
                }
                event.participantIDs.append(userID)
                self.notify()
            }
        }
    }
    
    func removeParticipantInEvent(event: Event, userID: String) {
        let db = FirebaseManager.shared.fireStore()
        let eventRef = db.collection("events").document(event.eventID)
        
        eventRef.updateData([
            "participantids": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
            } else {
                if (!event.participantIDs.contains(userID)) {
                    return
                }
                event.participantIDs.remove(at: event.participantIDs.firstIndex(of: userID)!)
                self.notify()
            }
        }
    }
    
    
    //    func getEventList() {
    //        let db = FirebaseManager.shared.fireStore()
    //        let uid = UserManager.shared.currentUser()?.uid
    //        //let users = UserManager.shared.users
    //        let agendas = AgendaManager.shared.agendas
    //
    //        agendas.map({$0.agendaID}).forEach( { agendaID in
    //            print("Check in agenda: " + agendaID)
    //            db.collection("events").whereField("agendaID", isEqualTo: agendaID).getDocuments() { (querySnapshot, err) in
    //
    //                if let err = err {
    //                } else {
    //                    self.events.removeAll()
    //                    for document in querySnapshot!.documents {
    //
    //                        let eventID = document.documentID
    //                        let agendaID = document["agendaID"] as! String
    //                        let eventName = document["name"] as! String
    //                        let placeName = document["place"] as! String
    //                        let cDate = (document["cdate"] as! Timestamp).dateValue()
    //                        let beginDate = (document["beginDate"] as! Timestamp).dateValue()
    //                        let endDate = (document["endDate"] as! Timestamp).dateValue()
    //
    //                        self.events.append(Event(agendaID: agendaID,placeName: placeName, eventID: eventID, eventName: eventName, cDate: cDate, beginDate: beginDate, endDate: endDate))
    //                        print(" Event: \(eventID)")
    //
    //
    //                    }
    ////                    self.notify()
    //                }
    //                self.events = self.events.sorted(by: { $0.beginDate < $1.beginDate })
    //            }
    //        })
    //    }
    
    //    func remainLessThan(event: Event) -> Int {
    //        return event.beginDate.compare(Date()).rawValue
    //    }
    
    //    func getAllEventList() {
    //        let db = FirebaseManager.shared.fireStore()
    //
    //        events = [Event]()
    //
    //        db.collection("events").getDocuments() { (querySnapshot, err) in
    //            if let err = err {
    //                print("Error getting documents: \(err)")
    //            } else {
    //                self.events.removeAll()
    //                for document in querySnapshot!.documents {
    //
    //                    let eventID = document.documentID
    //                    let agendaID = document["agendaID"] as! String
    //                    let eventName = document["name"] as! String
    //                    let placeName = document["place"] as! String
    //                    let cDate = document["cdate"] as! Timestamp
    //                    let beginDate = document["beginDate"] as! Timestamp
    //                    let endDate = document["endDate"] as! Timestamp
    //
    //                    self.events.append(Event(agendaID: agendaID,placeName: placeName, eventID: eventID, eventName: eventName, cDate: cDate.dateValue(), beginDate: beginDate.dateValue(), endDate: endDate.dateValue()))
    //
    //                    print("Event: \(document.documentID)")
    //
    //                    self.notify()
    //
    //                }
    //
    //            }
    //        }
    //        self.events = self.events.sorted(by: { $0.beginDate > $1.beginDate })
    //
    //    }
    
    func deleteEvent(eventID: String) {
        let db = FirebaseManager.shared.fireStore()
        
        db.collection("Events").document(eventID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.events = self.events.filter {
                    $0.eventID != eventID
                }
                print("Document successfully removed!")
            }
        }
    }
}

protocol EventObserver {
    func updateEventObservers()
}


