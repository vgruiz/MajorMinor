//
//  MinorItemCell.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 6/25/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import SwipeCellKit

class MinorItemCell: CustomCell {

    @IBOutlet weak var minorItemTitleLabel: UILabel!
    @IBOutlet weak var minorItemTitleTextField: UITextField!
    var minorItem : MinorItem!
    
    override func configure() {
        self.itemTitleLabel = minorItemTitleLabel
        self.itemTitleTextField = minorItemTitleTextField
        super.configure()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        do {
            try realm.write {
                minorItem.name = textField.text!
            }
        } catch {
            print("Error updating MinorItem \(error)")
        }
    }
}
