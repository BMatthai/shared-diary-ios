//
//  FormatHelper.swift
//  Agenda
//
//  Created by Bastien Matthai on 28/09/2019.
//  Copyright © 2019 Bastien MATTHAI. All rights reserved.
//

import UIKit

class FormatHelper: NSObject {

    static func DateToString(date: Date) -> String {
        let formatter = DateFormatter()
   
        formatter.dateFormat = "MM/dd/yyyy à HH:mm"
        return formatter.string(from: date)
    }
    
}
