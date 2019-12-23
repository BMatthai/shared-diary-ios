//
//  MoreViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 16/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet weak var signoutButton: UIButton!
    
    @IBOutlet var displayNameTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//       containerView.layer.borderWidth = 2
//       containerView.layer.cornerRadius = 10
        
        displayNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = UserManager.shared.currentUser()?.uid
        
        displayNameTextField.text = UserManager.shared.users.filter({ $0.userID == uid}).first?.displayName
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        AgendaManager.shared.detachAgendaObservers()
        EventManager.shared.detachEventObservers()
        UserManager.shared.detachUserObservers()
        UserManager.shared.signOut()
    }
    
    @IBAction func updateDisplayNameAction(_ sender: Any) {
        if (displayNameTextField.text == "") {
            return
        }
        
        let userID = UserManager.shared.currentUser()?.uid
        
        UserManager.shared.updateExistingUser(userID: userID!, displayName: self.displayNameTextField.text!)
    }

}
