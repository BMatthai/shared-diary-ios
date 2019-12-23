//
//  AgendaViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 25/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class AgendaDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, EventObserver, AgendaObserver, UserObserver  {
    
    
    
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var agendaNameLabel: UILabel!
    
    @IBOutlet weak var agendaThemeLabel: UILabel!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var userInTableView: UITableView!
    
    @IBOutlet weak var addUserInAgendaButton: UIButton!
    
    @IBOutlet weak var removeUserFromAgendaButton: UIButton!
    
    @IBOutlet weak var userOutTableView: UITableView!
    
    var selectedUser: AUser? = nil
    var agendaUsersOut: [AUser] = []
    var agendaUsersIn: [AUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        eventTableView.layer.borderWidth = 2
        eventTableView.layer.cornerRadius = 10
        
        userInTableView.layer.borderWidth = 2
        userInTableView.layer.cornerRadius = 10
        
        userOutTableView.layer.borderWidth = 2
        userOutTableView.layer.cornerRadius = 10
        
        addUserInAgendaButton.layer.borderWidth = 2
        addUserInAgendaButton.layer.cornerRadius = 10
        
        removeUserFromAgendaButton.layer.borderWidth = 2
        removeUserFromAgendaButton.layer.cornerRadius = 10
        
        addUserInAgendaButton.layer.borderWidth = 2
        addUserInAgendaButton.layer.cornerRadius = 10
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        userInTableView.delegate = self
        userInTableView.dataSource = self
        
        userOutTableView.delegate = self
        userOutTableView.dataSource = self
        
        EventManager.shared.attachObserver(eventObserver: self)
        UserManager.shared.attachObserver(userObserver: self)
        AgendaManager.shared.attachObserver(agendaObserver: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let agenda = AgendaManager.shared.agendas.filter( {$0.agendaID == AgendaManager.shared.selectedAgendaID} ).first
        
        self.agendaNameLabel.text = agenda?.agendaName
        self.agendaThemeLabel.text = agenda?.agendaTheme
        self.creationDateLabel.text = FormatHelper.DateToString(date: agenda!.cDate)
        
        AgendaManager.shared.getAgendaList()
        EventManager.shared.getEventList()
        UserManager.shared.getUserList()
        
        self.syncUserIDs()
    }
    
    func syncUserIDs() {
        let allUsers = UserManager.shared.users
        
        let selectedAgenda = AgendaManager.shared.agendas.filter({
            $0.agendaID == AgendaManager.shared.selectedAgendaID
        }).first
        
        if (selectedAgenda != nil) {
            agendaUsersOut = allUsers.filter({!(selectedAgenda?.userIDs.contains($0.userID))! })
            agendaUsersIn = allUsers.filter({(selectedAgenda?.userIDs.contains($0.userID))! })
        }
        
        self.userOutTableView.reloadData()
        self.userInTableView.reloadData()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (velocity.y < -1.5) {
            if (scrollView == self.eventTableView) {
                EventManager.shared.getEventList()
            }
            else if (scrollView == userOutTableView || scrollView == userInTableView) {
                AgendaManager.shared.getAgendaList()
                EventManager.shared.getEventList()
                UserManager.shared.getUserList()
                
                self.syncUserIDs()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == self.eventTableView) {
            return "Incoming events in this agenda"
        }
        else if (tableView == self.userInTableView){
            return "Users in"
        }
        else {
            return "Users out"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.eventTableView) {
            return EventManager.shared.events.filter({$0.agendaID == AgendaManager.shared.selectedAgendaID }).filter({$0.beginDate.timeIntervalSince(Date()) > (-12 * 60 * 60)}).count
        }
        else if (tableView == self.userOutTableView) {
            return agendaUsersOut.count
        }
        else {
            return agendaUsersIn.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.eventTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customeventcell", for: indexPath) as! EventListTableViewCell
            
            let event = EventManager.shared.events.filter({$0.agendaID == AgendaManager.shared.selectedAgendaID }).filter({$0.beginDate.timeIntervalSince(Date()) > (-12 * 60 * 60)})[indexPath.item]
            
            let timeInterval = event.beginDate.timeIntervalSince(Date())
            if (timeInterval < 1 * 60 * 60) {
                cell.backgroundColor = UIColor(red:1.00, green:0.72, blue:0.72, alpha:1.0)
            }
            else if (timeInterval < 24 * 60 * 60) {
                cell.backgroundColor = UIColor(red:1.00, green:0.84, blue:0.72, alpha:1.0)
            }
            else if (timeInterval < 72 * 60 * 60) {
                cell.backgroundColor = UIColor(red:1.00, green:0.97, blue:0.72, alpha:1.0)
            }
            else {
                cell.backgroundColor = UIColor(red:0.86, green:1.00, blue:0.72, alpha:1.0)
            }
            
            cell.eventNameLabel.text = event.eventName
            cell.creationDateLabel.text = FormatHelper.DateToString(date: event.beginDate)
            
            return cell
        }
        else if (tableView == self.userOutTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "useroutcell", for: indexPath)
            let userID = UserManager.shared.currentUser()?.uid
            
            cell.textLabel?.text = agendaUsersOut[indexPath.row].displayName
            
            if (userID == agendaUsersOut[indexPath.row].userID) {
                cell.textLabel?.textColor = UIColor.red
            }
            else {
                cell.textLabel?.textColor = UIColor.green
            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userincell", for: indexPath)
            let userID = UserManager.shared.currentUser()?.uid
            
            cell.textLabel?.text = agendaUsersIn[indexPath.row].displayName
            
            if (userID == agendaUsersIn[indexPath.row].userID) {
                cell.textLabel?.textColor = UIColor.red
            }
            else {
                cell.textLabel?.textColor = UIColor.green
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == self.eventTableView) {
            let event = EventManager.shared.events.filter({$0.agendaID == AgendaManager.shared.selectedAgendaID })[indexPath.row]
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            
            EventManager.shared.selectedEventID = event.eventID
            
            self.present(vc, animated: true, completion: nil)
        }
        else if (tableView == self.userOutTableView){
            self.selectedUser = agendaUsersOut[indexPath.row]
        }
        else {
            self.selectedUser = agendaUsersIn[indexPath.row]
        }
    }
    
    @IBAction func moveUserInAction(_ sender: Any) {
        if (selectedUser == nil) {
            return
        }
        
        let agenda = AgendaManager.shared.agendas.filter( {$0.agendaID == AgendaManager.shared.selectedAgendaID} ).first
        
        AgendaManager.shared.addUserInAgenda(agenda: agenda!, userID: selectedUser!.userID)
        selectedUser = nil
    }
    
    @IBAction func moveUserOutAction(_ sender: Any) {
        if (selectedUser?.userID == UserManager.shared.currentUser()?.uid) {
            return
        }
        if (selectedUser == nil) {
            return
        }
        
        let agenda = AgendaManager.shared.agendas.filter( {$0.agendaID == AgendaManager.shared.selectedAgendaID} ).first
        
        AgendaManager.shared.removeUserFromAgenda(agenda: agenda!, userID: selectedUser!.userID)
        selectedUser = nil
    }
    
    func updateAgendaObservers() {
        self.syncUserIDs()
        
        //        self.userOutTableView.reloadData()
        //        self.userInTableView.reloadData()
    }
    
    func updateEventObservers() {
        self.eventTableView.reloadData()
    }
    
    func updateUserObservers() {
        self.syncUserIDs()
        
        //        self.userOutTableView.reloadData()
        //        self.userInTableView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventCreationViewController") as! EventCreationViewController
        
        self.present(vc, animated: true, completion: nil)
    }
}

protocol EventCellDelegate : class {
    func didClickOnEventCell(_ tag: Int)
    //        func didClickOnDeleteButton(_ tag: Int)
}

