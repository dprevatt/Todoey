//
//  Item.swift
//  Todoey
//
//  Created by Dustin Prevatt on 12/17/18.
//  Copyright © 2018 Dustin Prevatt. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // Creating Relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
