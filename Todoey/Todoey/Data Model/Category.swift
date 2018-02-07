//
//  Category.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-02-04.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
