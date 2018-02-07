//
//  Item.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-02-04.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: NSDate?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
