//
//  EventDetailViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 01/10/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, EventObserver {
    
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var switchIParticipate: UISwitch!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                

        EventManager.shared.attachObserver(eventObserver: self)
        
        self.participantTableView.delegate = self
        self.participantTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.event = EventManager.shared.events.filter({$0.eventID == EventManager.shared.selectedEventID }).first
        
        eventNameLabel.text = "Event name: " + self.event!.eventName
        beginDateLabel.text = "Begins at " + FormatHelper.DateToString(date:  self.event!.beginDate)
        endDateLabel.text = "Finish at " + FormatHelper.DateToString(date:   self.event!.endDate)
        eventPlaceLabel.text = "Place: " + self.event!.placeName
        
        
        
        EventManager.shared.getEventList()
        
        switchIParticipate.isOn = (self.event?.participantIDs.contains(UserManager.shared.currentUser()!.uid))!
    }
    
    @IBAction func switchParticipationAction(_ sender: Any) {
        if (switchIParticipate.isOn) {
            EventManager.shared.addParticipantInEvent(event: self.event!, userID: UserManager.shared.currentUser()!.uid)
        }
        else {
            EventManager.shared.removeParticipantInEvent(event: self.event!, userID: UserManager.shared.currentUser()!.uid)
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil) 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.event!.participantIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantcell", for: indexPath)
        
        cell.textLabel!.text = UserManager.shared.users.filter({$0.userID == self.event!.participantIDs[indexPath.row] }).first?.displayName
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (velocity.y < -1.5) {
            
            EventManager.shared.getEventList()
        }
    }
    
    func updateEventObservers() {
        self.participantTableView.reloadData()
        //self.switchIParticipate.reloadInputViews()
    }
    
}

