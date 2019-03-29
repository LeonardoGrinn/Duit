//
//  Category.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/24/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()  //Array of items
}

