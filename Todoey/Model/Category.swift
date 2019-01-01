//
//  Category.swift
//  Todoey
//
//  Created by Dustin Prevatt on 12/17/18.
//  Copyright © 2018 Dustin Prevatt. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = ""

    // Creating Relationship
    let items = List<Item>()
}
