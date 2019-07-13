//
//  MinorItem.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 6/12/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import Foundation
import RealmSwift

class MajorItem: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var complete: Bool = false
    let minorItems = List<MinorItem>()
}
