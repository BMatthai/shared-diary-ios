//
//  EventCreationViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 02/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class EventCreationViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, AgendaObserver {

    
    
    
    //var selectedAgenda = AgendaManager.shared.selectedAgenda
    
    @IBOutlet weak var eventAgendaPicker: UIPickerView!
    
    @IBOutlet weak var eventNameTextfield: UITextField!
    
    @IBOutlet weak var eventPlaceTextfield: UITextField!
    
    @IBOutlet weak var eventBeginDatePicker: UIDatePicker!
    
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    
    func updateAgendaObservers() {
        eventAgendaPicker.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventAgendaPicker.dataSource = self
        eventAgendaPicker.delegate = self
        
        eventPlaceTextfield.delegate = self
        eventNameTextfield.delegate = self
        
        let selectedRow = AgendaManager.shared.agendas.firstIndex(where: { $0.agendaID == AgendaManager.shared.selectedAgendaID })
        
        self.eventAgendaPicker.selectRow(selectedRow ?? 0, inComponent: 0, animated: false)
        
        AgendaManager.shared.attachObserver(agendaObserver: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AgendaManager.shared.agendas.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AgendaManager.shared.agendas[row].agendaName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        AgendaManager.shared.selectedAgendaID = AgendaManager.shared.agendas[row].agendaID
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        let selectedAgendaID =  AgendaManager.shared.selectedAgendaID
        let eventName = self.eventNameTextfield.text!
        let eventPlace = self.eventPlaceTextfield.text!
        let beginDate = self.eventBeginDatePicker.date
        var endDate = self.eventEndDatePicker.date
        
        if (eventName == "") {
            return
        }
        
        if (eventPlace == "") {
            return
        }
        if (beginDate > endDate) {
            endDate = beginDate
        }
 
       EventManager.shared.createEvent(agendaID: selectedAgendaID, placeName: eventPlace, eventName: eventName, beginDate: self.eventBeginDatePicker.date, endDate: self.eventEndDatePicker.date)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
                
        self.present(vc, animated: true, completion: nil)
    }
   
    
    
    
}
