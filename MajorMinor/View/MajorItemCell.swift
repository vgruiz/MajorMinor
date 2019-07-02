//
//  MajorItemCell.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 6/24/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import SwipeCellKit

class MajorItemCell: SwipeTableViewCell {

    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var majorItemCellTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @objc func editCellTitle(sender: UIGestureRecognizer)  {
        titleTextField.text = majorItemCellTitle.text
        majorItemCellTitle.isHidden = true
        titleTextField.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        //titleTextField.isHidden = false
        //majorItemCellTitle.isHidden = true
        print("initializing")
    }
}
