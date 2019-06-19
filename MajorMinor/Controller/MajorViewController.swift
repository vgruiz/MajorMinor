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


class CustomMajorCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    
}

class MajorViewController: UITableViewController{
    
    let realm = try! Realm()
    
    var majorItems: Results<MajorItem>?
    var numCompletedTasks: Int!
    var numTotalTasks: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.flatWhite()
        loadItems()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorItems?.count ?? 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCell", for: indexPath) as! CustomMajorCell
        
        cell.textLabel?.text = majorItems?[indexPath.row].name
        
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
        
        cell.statusLabel.text = "\(numCompletedTasks ?? 0) / \(numTotalTasks ?? 0)"

        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMinorList", sender: self)
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
            newItemTitle = textBox.text as! String ?? "Blank Item"
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
}
