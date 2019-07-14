//
//  MajorItemCell.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 6/24/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class MajorItemCell: CustomCell {

    @IBOutlet weak var majorItemTitleLabel: UILabel!
    @IBOutlet weak var majorItemTitleTextField: UITextField!
    @IBOutlet weak var listStatusLabel: UILabel! //only for MajorItems
    @IBOutlet weak var checkmark: UIImageView!
    var majorItem : MajorItem!
    
    var tapCheckmark = UITapGestureRecognizer()
    
    override func configure() {
        self.itemTitleLabel = majorItemTitleLabel
        self.itemTitleTextField = majorItemTitleTextField
        super.configure()
        configureCheckmark()
    }
    
    private func configureCheckmark() {
        checkmark.isHidden = true
        checkmark.isUserInteractionEnabled = true
        
        tapCheckmark = UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped))
        checkmark.addGestureRecognizer(tapCheckmark)
        tapCheckmark.delegate = self
    }

    @objc private func checkmarkTapped() {
        itemTitleTextField.resignFirstResponder()
    }

    override func editLabel() {
        super.editLabel()
        checkmark.isHidden = false
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        checkmark.isHidden = true

        do {
            try realm.write {
                majorItem.name = majorItemTitleTextField.text!
            }
        } catch {
            print("Error updating MajorItem \(error)")
        }
    }
    
}
