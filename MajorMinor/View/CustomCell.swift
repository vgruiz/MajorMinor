//
//  CustomCell.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 7/13/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class CustomCell: SwipeTableViewCell, UITextFieldDelegate {

    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    let realm = try! Realm()
    
    func configure() {
        configureTextField()
        configureLabel()
        configureTapGesture()
    }
    
    private func configureTextField() {
        itemTitleTextField.delegate = self
        itemTitleTextField.isHidden = true
    }
    
    private func configureLabel() {
        itemTitleLabel.isUserInteractionEnabled = true
    }
    
    private func configureTapGesture() {
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(editLabel))
        labelTapGesture.numberOfTapsRequired = 1
        itemTitleLabel.addGestureRecognizer(labelTapGesture)
    }

    @objc func editLabel() {
        print("editLabel() pressed")
        itemTitleLabel.isHidden = true
        itemTitleTextField.isHidden = false
        itemTitleTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemTitleLabel.text = itemTitleTextField.text
        itemTitleLabel.isHidden = false
        itemTitleTextField.isHidden = true
    }

}
