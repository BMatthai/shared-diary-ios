//
//  ViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 24/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class AgendaCreationViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var agendaNameTextfield: UITextField!
    @IBOutlet var createAgendaButton: UIButton!
    @IBOutlet weak var themePicker: ThemePicker!
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.themePicker.dataSource = self
        self.themePicker.delegate = self
        
//        containerView.layer.borderWidth = 2
//        containerView.layer.cornerRadius = 10
    }
    
    @IBAction func addAgendaAction(_ sender: Any) {
        let agendaName = self.agendaNameTextfield.text!
        let userName = (UserManager.shared.currentUser()?.uid)!
        let agendaTheme = self.themePicker.themes[self.themePicker.selectedRow(inComponent: 0)]
        
        if (agendaName == "") {
            return
        }
        if (userName == "") {
            return
        }
        if (agendaTheme == "") {
            return
        }
        
        AgendaManager.shared.createAgenda(userID: userName, agendaName: agendaName, agendaTheme: agendaTheme)
        successAction()
    }
    
    func successAction() {
        navigationController?.popViewController(animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themePicker.themes.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return themePicker.themes[row]
    }
}
