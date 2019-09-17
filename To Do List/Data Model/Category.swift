//
//  Category.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 9/11/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
