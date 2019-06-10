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
import CoreData


class MinorViewController: UITableViewController {
    
    var minorItems = [MinorItem]()
    var selectedMajorItem : MajorItem?
    {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.randomFlat()
        
        loadItems()
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
        
        if minorItem.complete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = minorItems[indexPath.row]
        item.complete = !item.complete
        //context.delete(minorItems[indexPath.row])
        minorItems.remove(at: indexPath.row)
        saveItems()
        tableView.reloadData()
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
            
            let newMinorItem = MinorItem(context: self.context)
            newMinorItem.name = textBox.text as! String
            newMinorItem.parentCategory = self.selectedMajorItem
            self.minorItems.append(newMinorItem)
            self.saveItems()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(addAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedMajorItem!.name!)
        
        let request : NSFetchRequest<MinorItem> = MinorItem.fetchRequest()
        request.predicate = predicate
        
        do {
            minorItems = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}
