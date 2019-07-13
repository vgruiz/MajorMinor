//
//  MinorItem.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 6/12/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import Foundation
import RealmSwift

class MinorItem: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var complete: Bool = false
    @objc dynamic var discarded: Bool = false
    @objc dynamic var index = Int()
    //@objc dynamic var test = Int()
    var parent = LinkingObjects(fromType: MajorItem.self, property: "minorItems")
}
