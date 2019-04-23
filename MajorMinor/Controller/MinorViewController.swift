//
//  MinorViewController.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 4/22/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MinorViewController: UITableViewController {
    
    var minorItems = [MinorItem]()
    var selectedMajorItem : MajorItems?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.randomFlat()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minorItems.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MinorCell", for: indexPath)

        let minorItem = minorItems[indexPath.row]
        cell.textLabel?.text = minorItem.name

        return cell
    }

    @IBAction func addMinorItem(_ sender: UIBarButtonItem) {
        var textBox = UITextField()
        
        let alert = UIAlertController(title: "Add Minor Item", message: "test", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Begin Typing"
            textBox = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            action.isEnabled = false
            if textBox.text != nil {
                action.isEnabled = true
            }
            let newMinorItem = MinorItem()
            newMinorItem.name = textBox.text as! String
            self.minorItems.append(newMinorItem)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(addAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
