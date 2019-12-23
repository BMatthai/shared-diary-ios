//
//  FirebaseManager.swift
//  Agenda
//
//  Created by Bastien Matthai on 24/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirebaseManager: NSObject {
    static let shared = FirebaseManager()
    
    private override init() {
    }
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func fireStore() -> Firestore {
        return Firestore.firestore()
    }
}
