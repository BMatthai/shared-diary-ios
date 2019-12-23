//
//  EventListTableViewCell.swift
//  Agenda
//
//  Created by Bastien Matthai on 29/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {

    var eventCellDelegate: EventCellDelegate?

    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
