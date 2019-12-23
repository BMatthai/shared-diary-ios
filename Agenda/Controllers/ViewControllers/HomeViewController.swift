//
//  HomeViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 29/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,
UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, EventObserver, AgendaObserver  {
    
    
    
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var createEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        //        eventTableView.layer.borderWidth = 2
        //        eventTableView.layer.cornerRadius = 10
        
        AgendaManager.shared.attachObserver(agendaObserver: self)
        EventManager.shared.attachObserver(eventObserver: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        EventManager.shared.getEventList()
        UserManager.shared.getUserList()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (velocity.y < -1.5) {
            EventManager.shared.getEventList()
        }
    }
    
    
    //    MARK: TableView methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My incoming events"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventManager.shared.events.filter({$0.beginDate.timeIntervalSince(Date()) > (-12 * 60 * 60)}).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfRow = tableView.numberOfRows(inSection: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customeventcell", for: indexPath) as! EventListTableViewCell
        
        let event = EventManager.shared.events.filter({$0.beginDate.timeIntervalSince(Date()) > (-12 * 60 * 60)})[indexPath.row]
        let agenda = AgendaManager.shared.agendas.filter({$0.agendaID == event.agendaID }).first
        
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
        
        
        cell.eventNameLabel.text = event.eventName + " (" + (agenda?.agendaName ?? "unknown") + ")"
        cell.creationDateLabel.text = FormatHelper.DateToString(date: event.beginDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        
        EventManager.shared.selectedEventID = EventManager.shared.events[indexPath.row].eventID
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventCreationViewController") as! EventCreationViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //    func didClickOnEventCell(_ tag: Int) {
    //        let event = EventManager.shared.events[tag]
    //
    //          let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //          let vc = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
    //
    //          EventManager.shared.selectedEvent = event
    //
    //          self.present(vc, animated: true, completion: nil)
    //    }
    //
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //
    //    }
    
    
    //    MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (AgendaManager.shared.selectedAgendaID == "") {
            AgendaManager.shared.selectedAgendaID = AgendaManager.shared.agendas[0].agendaID
        }
    }
    
    // MARK: Update Observers
    func updateEventObservers() {
        self.eventTableView.reloadData()
    }
    
    func updateAgendaObservers() {
        self.createEventButton.isEnabled = AgendaManager.shared.agendas.isEmpty ? false : true
    }
}
