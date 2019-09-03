//
//  ViewController.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 8/28/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //hard coded todo items for testing
    var itemArray = [Item]()
    
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
        //    itemArray = items
        //}
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.accessoryType()
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        //set done property to opposite of what it is
        item.toggleDone()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = item.accessoryType()
        
        self.saveItems()
        
        //deselect item so that every item selected isn't grayed out
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Button Functionality
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //setup
        var textField : UITextField = UITextField()
        
        //prompt user to input new list item
        let alert = UIAlertController(title: "Add to do list item", message: "", preferredStyle: .alert)
        
        //add add item button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //add to list
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //save locally
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
            //add to table view
            self.tableView.reloadData()
        }
        
        //add text field for user
        alert.addTextField { (alertTextField) in
            //set up text field
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //add add item action
        alert.addAction(action)
        
        //present alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
            
        } catch{
            print(error)
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print(error)
            }
        }
    }
    
    
}

