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

class MajorItemCell: SwipeTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var majorItemCellTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var checkmark: UIImageView!
    var majorItem : MajorItem!
    
    let realm = try! Realm()
    
    var tapCheckmark = UITapGestureRecognizer()
    
    func configureCell() {
        checkmark.isHidden = true
        checkmark.isUserInteractionEnabled = true
        
        configureTextField()
        configureLabel()
        configureTapGesture()
        
        tapCheckmark = UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped))
        checkmark.addGestureRecognizer(tapCheckmark)
        tapCheckmark.delegate = self
    }
    
    @objc private func checkmarkTapped() {
        titleTextField.resignFirstResponder()
    }
    
    private func configureTextField() {
        titleTextField.delegate = self
        titleTextField.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        majorItemCellTitle.text = titleTextField.text
        majorItemCellTitle.isHidden = false
        titleTextField.isHidden = true
        checkmark.isHidden = true
        
        do {
            try realm.write {
                majorItem.name = titleTextField.text!
            }
        } catch {
            print("Error updating MajorItem \(error)")
        }
    }
    
    private func configureLabel() {
        majorItemCellTitle.isUserInteractionEnabled = true
    }
    
    private func configureTapGesture() {
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(editLabel))
        labelTapGesture.numberOfTapsRequired = 1
        majorItemCellTitle.addGestureRecognizer(labelTapGesture)
    }

    @objc private func editLabel() {
        print("editLabel() pressed")
        majorItemCellTitle.isHidden = true
        titleTextField.isHidden = false
        titleTextField.becomeFirstResponder()
        checkmark.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        //titleTextField.isHidden = false
        //majorItemCellTitle.isHidden = true
        print("initializing")
    }
}
