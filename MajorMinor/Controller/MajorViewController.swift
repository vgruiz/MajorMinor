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

class MajorViewController: UITableViewController{
    
    var majorItems = [MajorItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.randomFlat()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorItems.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCell", for: indexPath)
        
        let item = majorItems[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(majorItems[indexPath.row].name)
        performSegue(withIdentifier: "goToMinorList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MinorViewController
        
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedMajorItem = majorItems[indexPath.row]
        destVC.selectedMajorItem = selectedMajorItem
    }
    
    //MARK: - Add Major Item
    @IBAction func addMajorItem(_ sender: Any) {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)
        var textBox = UITextField()
        var newItemTitle : String = ""
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new major item"
            textBox = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            newItemTitle = textBox.text as! String ?? "Blank Item"
            let newMajorItem = MajorItems()
            newMajorItem.name = newItemTitle
            self.majorItems.append(newMajorItem)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
}
