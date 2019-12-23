//
//  AgendaAPI.swift
//  Agenda
//
//  Created by Bastien Matthai on 24/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit
import Firebase

class AgendaManager: NSObject, UserObserver {
    
    func updateUserObservers() {
        getAgendaList()
        
    }
    
    static let shared = AgendaManager()
    var agendas = [Agenda]()
    var selectedAgendaID: String = ""
    
    var agendaObservers = [AgendaObserver]()
    
    private override init() {
        super.init()
        UserManager.shared.attachObserver(userObserver: self)
    }
    
    func attachObserver(agendaObserver: AgendaObserver) {
        agendaObservers.append(agendaObserver)
    }
    
    private func notify() {
        for observer in agendaObservers {
            observer.updateAgendaObservers()
        }
    }
    
    func detachAgendaObservers() {
        agendaObservers.removeAll()
    }
    
    func createAgenda(userID: String, agendaName: String, agendaTheme: String) {
        let db = FirebaseManager.shared.fireStore()
        let agendaID = agendaName + "@" + userID
        let cDate = Timestamp()
        
        db.collection("agendas").document(agendaID).setData([
            "name": agendaName,
            "theme": agendaTheme,
            "cdate": cDate,
            "admin": [userID],
            "userids": [userID]
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                
                //self.agendas.append(Agenda(agendaID: agendaID, agendaName: agendaName, agendaTheme: agendaTheme, cDate: cDate.dateValue(), userIDs: [userID]))
                //self.notify()
                print("Document successfully written!")
            }
        }
    }
    
    func getAgendaList() {
        let db = FirebaseManager.shared.fireStore()
        let uid = UserManager.shared.currentUser()?.uid
        
        db.collection("agendas").whereField("userids", arrayContains: uid!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.agendas.removeAll()
                for document in querySnapshot!.documents {
                    let agendaID = document.documentID
                    let agendaName = document["name"]
                        as! String
                    let agendaTheme = document["theme"] as! String
                    let cDate = document["cdate"] as! Timestamp
                    let userIDs = document["userids"] as! [String]
                    
                    self.agendas.append(Agenda(agendaID: agendaID, agendaName: agendaName, agendaTheme: agendaTheme, cDate: cDate.dateValue(), userIDs: userIDs))
                    
                    print("Agenda: \(document.documentID)")
                }
                 self.notify()
            }
        }
    }
    
    func addUserInAgenda(agenda: Agenda, userID: String) {
        let db = FirebaseManager.shared.fireStore()
        let agendaRef = db.collection("agendas").document(agenda.agendaID)
        
        agendaRef.updateData([
            "userids": FieldValue.arrayUnion([userID])
        ]){ err in
            if let err = err {
                
            } else {
                if (agenda.userIDs.contains(userID)) {
                    return
                }
                agenda.userIDs.append(userID)
                self.notify()

            }
        }
    }
    
    func removeUserFromAgenda(agenda: Agenda, userID: String) {
        let db = FirebaseManager.shared.fireStore()
        let agendaRef = db.collection("agendas").document(agenda.agendaID)
        
        agendaRef.updateData([
            "userids": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
                
            } else {
                if (!agenda.userIDs.contains(userID)) {
                    return
                }
                agenda.userIDs.remove(at: agenda.userIDs.firstIndex(of: userID)!)
                self.notify()
            }
        }
    }
    
    func deleteAgenda(agendaID: String) {
        let db = FirebaseManager.shared.fireStore()
        
        db.collection("agendas").document(agendaID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.agendas = self.agendas.filter { $0.agendaID != agendaID }
                
//                if (self.selectedAgenda?.agendaID == agendaID) {
//                    self.selectedAgenda = self.agendas[0]
//                }
                self.notify()
                print("Document successfully removed!")
            }
        }
    }
    
}

protocol AgendaObserver {
    
    func updateAgendaObservers()
}
