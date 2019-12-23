//
//  TabBarViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 16/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignOut), name: NSNotification.Name("SuccessfulSignOutNotification"), object: nil)
    }
    
    
    @objc func didSignOut()  {
        
        UserManager.shared.updateRootVC()
        
        let signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
    
}
