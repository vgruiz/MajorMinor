//
//  MajorViewController.swift
//  MajorMinor
//
//  Created by Victor Ruiz on 4/9/19.
//  Copyright © 2019 Victor Ruiz. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift
import SwipeCellKit

class MajorViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    var majorItems: Results<MajorItem>?
    var numCompletedTasks: Int!
    var numTotalTasks: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.init(hexString: "#ffe5b8")
        loadItems()
        tableView.rowHeight = UITableView.automaticDimension
        //UIColor.init(hexString: "#f7f1e3")
        tableView.estimatedRowHeight = 70
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return majorItems?.count ?? 1
        return (majorItems?.count ?? 0) + 1 //the extra 1 is for the "add new item" button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //for when you return to the MajorViewController, to update the statusLabel
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //print(indexPath.row)
        if indexPath.row != majorItems?.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MajorItemCell", for: indexPath) as! MajorItemCell
            
            cell.delegate = self
            
            //cell.textLabel?.text = majorItems?[indexPath.row].name
            cell.majorItemCellTitle.text = majorItems?[indexPath.row].name
            
            //update statusLabel
            numCompletedTasks = 0
            numTotalTasks = 0
            
            if let minorItems = majorItems?[indexPath.row].minorItems {
                for x in minorItems {
                    if x.complete {
                        numCompletedTasks += 1
                        numTotalTasks += 1
                    } else {
                        numTotalTasks += 1
                    }
                }
            }
            
            cell.majorItemCellTitle.isUserInteractionEnabled = true
            let tap = UIGestureRecognizer(target: MajorItemCell.self, action: #selector(MajorItemCell.editCellTitle))
            cell.majorItemCellTitle.addGestureRecognizer(tap)
            
            cell.listStatusLabel.text = "\(numCompletedTasks ?? 0) / \(numTotalTasks ?? 0)"
            
            cell.backgroundColor = UIColor.init(hexString: "#f7f1e3")
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewItemCell", for: indexPath) as! MajorItemCell
            
            cell.delegate = self
            
            return cell
            
        }
        
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "AddNewItemCell" {
            //print("Butts")
            self.addMajorItem(self)
        } else {
            performSegue(withIdentifier: "goToMinorList", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MinorViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedMajorItem = majorItems?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods

    @IBAction func addMajorItem(_ sender: Any) {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)
        var textBox = UITextField()
        var newItemTitle : String = ""
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new major item"
            textBox = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            newItemTitle = textBox.text!
            let newMajorItem = MajorItem()
            newMajorItem.name = newItemTitle
            self.save(newMajorItem: newMajorItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func save(newMajorItem: MajorItem) {
        do {
            try realm.write {
                realm.add(newMajorItem)
            }
        } catch {
            print("Error saving items \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        majorItems = realm.objects(MajorItem.self)
        
        tableView.reloadData()
    }
    
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
    }
    
    
}

//MARK: SwipeCellKit Delegate Methods

extension MajorViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion

            if let itemForDeletion = self.majorItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("Error deleting Major Item, \(error)")
                }
            }
            //self.tableView.deleteRows(at: [indexPath], with: .none)
            self.majorItems = self.realm.objects(MajorItem.self)
            self.loadItems()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
//
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()

        options.expansionStyle = .selection

        return options

    }
}
