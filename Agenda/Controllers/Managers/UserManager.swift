//
//  AuthenticationManager.swift
//  Agenda
//
//  Created by Bastien Matthai on 16/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

import FirebaseAuth

class UserManager: NSObject {
    
    static let shared = UserManager()
    var users = [AUser]()
    var userObservers = [UserObserver]()
    
    private override init() {
    }
    
    func attachObserver(userObserver: UserObserver) {
        userObservers.append(userObserver)
    }
    
    private func notify() {
        for observer in userObservers {
            observer.updateUserObservers()
        }
    }
    
    func detachUserObservers() {
        userObservers.removeAll()
    }
    
    func updateRootVC() {
        var rootVC : UIViewController?
        if ((UserManager.shared.currentUser()) != nil) {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        }
        else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = rootVC
    }
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func signIn(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                return
            }
            else {
                let user = self.currentUser()
                self.createUnexistingUser(userID: user!.uid, userDisplayName: user?.displayName ?? "unknown user")
                self.notify()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.notify()
        } catch let err {
            print(err)
        }
    }
    
    func getUserList() {
        let db = FirebaseManager.shared.fireStore()
    
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.users.removeAll()
                
                for document in querySnapshot!.documents {
                    let userID = document.documentID
                    let displayName = document["displayname"] as! String
                    self.users.append(AUser(userID: userID, displayName: displayName))
                }
                self.notify()
            }
        }
    }
    
    func createUnexistingUser(userID: String, userDisplayName: String) {
        let db = FirebaseManager.shared.fireStore()
        
        db.collection("users").whereField("userid", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                //                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot!.isEmpty) {
                    db.collection("users").document(userID).setData([
                        "userid" : userID,
                        "displayname" : userDisplayName
                    ]) { err in
                        if let err = err {
                            //                            print("Error writing document: \(err)")
                        } else {
                            //                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
    }
    
  
    func updateExistingUser(userID: String, displayName: String) {
        let db = FirebaseManager.shared.fireStore()
        let agendaRef = db.collection("users").document(userID)
        
        agendaRef.updateData([
            "displayname": displayName
        ]){ err in
            if let err = err {
                
            } else {
                
                //                agenda.userIDs.append(userID)
                //                self.notify()
            }
        }
    }
}

protocol UserObserver {
    func updateUserObservers()
}
