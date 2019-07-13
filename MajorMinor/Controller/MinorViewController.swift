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
import SwipeCellKit

class MinorViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    
    var minorItems : Results<MinorItem>?
    var selectedMajorItem : MajorItem?
    {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.backgroundColor = UIColor.init(hexString: "#ffda79")
        
        loadItems()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (minorItems?.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != minorItems?.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MinorCell", for: indexPath) as! MinorItemCell
            
            cell.delegate = self
            
            if let minorItem = minorItems?[indexPath.row] {
                if minorItem.discarded {
                    cell.minorItemCellTitle.text = minorItem.name + " (discarded)"
                } else {
                    cell.minorItemCellTitle.text = minorItem.name
                }
                
                if minorItem.complete {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            cell.backgroundColor = UIColor.init(hexString: "#f7f1e3")
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "AddNewItemCell", for: indexPath) as! MinorItemCell
        }
        
    }
    
    //TODO: Make this edit the label within the tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "AddNewItemCell" {
            self.addMinorItem(UIBarButtonItem())
        }
        
    }

    @IBAction func startEditing(_ sender: Any) {
        isEditing = !isEditing
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = minorItems?[sourceIndexPath.row]
        //minorItems?.
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
            
            if let currentMajorItem = self.selectedMajorItem {
                do {
                    try self.realm.write {
                        let newMinorItem = MinorItem()
                        newMinorItem.name = textBox.text!
                        //newMinorItem.index = tableView.numberOfRows(inSection: 0) - 1
                        print(self.tableView.numberOfRows(inSection: 0))
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
                realm.add(newMinorItem)
            }
        } catch {
            print("Error saving items \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        minorItems = selectedMajorItem?.minorItems.sorted(byKeyPath: "name", ascending: true)
        //minorItems = minorItems?.filter("discarded == false")
        
        let sortProperties = [SortDescriptor(keyPath: "discarded"), SortDescriptor(keyPath: "complete")]
        
//        minorItems = minorItems?.sorted(byKeyPath: "discarded").sorted(byKeyPath: "complete")
        minorItems = minorItems?.sorted(by: sortProperties)
        
        tableView.reloadData()
    }
}

extension MinorViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        //guard orientation == .right else { return nil }

        if orientation == .right {
            
            
            let checkAction = SwipeAction(style: .default, title: "Complete") { (action, indexPath) in

                if let item = self.minorItems?[indexPath.row] {
                    do {
                        try self.realm.write {
                            item.complete = !item.complete
                        }
                    } catch {
                        print("Error updating completion status, \(error)")
                    }
                }

                self.loadItems()
            }

            checkAction.image = UIImage(named: "checkmark")
            checkAction.backgroundColor = .init(hexString: "179129")

            return [checkAction]
        } else {

            let discardAction = SwipeAction(style: .default, title: "Discard") { (action, indexPath) in
                print("item discarded")
                if let item = self.minorItems?[indexPath.row] {
                    //set discarded == true
                    do {
                        try self.realm.write {
                            item.discarded = !item.discarded
                            //self.realm.delete(item)
                        }
                        //self.tableView.deleteRows(at: [indexPath], with: .none)
                    } catch {

                    }
                    //set appearance to disabled
                    //send to bottom of the list
                }
                self.loadItems()
            }

            discardAction.backgroundColor = .init(hexString: "138693")

            return [discardAction]
        }

    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection

        return options
    }
}
