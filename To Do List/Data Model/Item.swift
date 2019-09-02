//
//  Item.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 9/2/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import UIKit

class Item{
    var title : String = ""
    var done  : Bool = false
    
    func toggleDone(){
        self.done = !self.done
    }
    
    func accessoryType() -> UITableViewCell.AccessoryType{
        return done ? .checkmark : .none
    }
}
