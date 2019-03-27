//
//  Item.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/24/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
