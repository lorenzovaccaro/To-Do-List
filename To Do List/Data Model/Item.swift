//
//  Item.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 9/11/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
