//
//  AgendaTableViewCell.swift
//  Agenda
//
//  Created by Bastien Matthai on 25/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class AgendaListTableViewCell: UITableViewCell {
    
    var agendaCellDelegate: AgendaCellDelegate?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        agendaCellDelegate?.didClickOnDeleteButton(sender.tag)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        agendaCellDelegate?.didClickOnEditButton(sender.tag)
    }
    
    
    

}
