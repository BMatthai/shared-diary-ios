//
//  AgendaListTableViewController.swift
//  Agenda
//
//  Created by Bastien Matthai on 25/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class AgendaListTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, AgendaCellDelegate, AgendaObserver {
    
    @IBOutlet weak var agendaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agendaTableView.delegate = self
        agendaTableView.dataSource = self
        
        //        agendaTableView.layer.borderWidth = 2
        //        agendaTableView.layer.cornerRadius = 10
        
        AgendaManager.shared.attachObserver(agendaObserver: self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AgendaManager.shared.getAgendaList()
        UserManager.shared.getUserList()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (velocity.y < -1.5) {
            AgendaManager.shared.getAgendaList()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My agendas"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AgendaManager.shared.agendas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfRow = tableView.numberOfRows(inSection: 1)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customagendacell", for: indexPath) as! AgendaListTableViewCell
        
        cell.agendaCellDelegate = self
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.nameLabel?.text = AgendaManager.shared.agendas[indexPath.item].agendaName
        
        return cell
    }
    
    func didClickOnEditButton(_ tag: Int) {        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
        
        AgendaManager.shared.selectedAgendaID = AgendaManager.shared.agendas[tag].agendaID
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func didClickOnDeleteButton(_ tag: Int) {
        let agendaID = AgendaManager.shared.agendas[tag].agendaID
        
        AgendaManager.shared.deleteAgenda(agendaID: agendaID)
    }
    
    //    @IBAction func refreshAction(_ sender: Any) {
    //        self.agendaTableView.reloadData()
    //    }
    
    func updateAgendaObservers() {
        self.agendaTableView.reloadData()
    }
}

protocol AgendaCellDelegate : class {
    func didClickOnEditButton(_ tag: Int)
    func didClickOnDeleteButton(_ tag: Int)
}

