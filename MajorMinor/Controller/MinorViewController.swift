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
    
    let realm = try! Realm()
    
    var minorItems : Results<MinorItem>?
    var selectedMajorItem : MajorItem?
    {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.randomFlat()
        
        loadItems()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minorItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MinorCell", for: indexPath)

        if let minorItem = minorItems?[indexPath.row] {
            cell.textLabel?.text = minorItem.name
            
            if minorItem.complete {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = "No Minor Items Created Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = minorItems?[indexPath.row] {
            do {
                try realm.write {
                    item.complete = !item.complete
                }
            } catch {
                print("Error saving complete status \(error)")
            }
        }
        
        tableView.reloadData()
    }

    @IBAction func addMinorItem(_ sender: UIBarButtonItem) {
        var textBox = UITextField()
        var newItemTitle: String = ""
        
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
            
            if let currentMajorItem = self.selectedMajorItem {
                do {
                    try self.realm.write {
                        let newMinorItem = MinorItem()
                        newMinorItem.name = textBox.text as! String
                        currentMajorItem.minorItems.append(newMinorItem)
                    }
                } catch {
                    print("Error adding a new minor item \(error)")
                }
                
            }
        
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(addAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func save(newMinorItem: MinorItem) {
        do {
            try realm.write {
                try realm.add(newMinorItem)
            }
        } catch {
            print("Error saving items \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        minorItems = selectedMajorItem?.minorItems.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
}
