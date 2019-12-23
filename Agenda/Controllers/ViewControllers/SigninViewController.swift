//
//  SigninViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 16/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

class SigninViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
    }
    
    @objc func didSignIn()  {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
