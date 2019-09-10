//
//  ViewController.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 8/28/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //hard coded todo items for testing
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set controller to be the search bar delegate
        searchBar.delegate = self
        
        //load data
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        //set done property to opposite of what it is
        item.done = !item.done
        
        //show the checkmark when select
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            //create new item
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory!
            
            //add to list
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
        do{
            try self.context.save()
        } catch{
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //need a predicate to load items in a certain category rather than load all of them
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //when searching you would like for that to work too, so you make a list of predicates
        //optional binding for the predicate parameter
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

        
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("Error loading data: \(error)")
        }
        
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if there is no text (i.e. the text was cleared) reset it
        if searchBar.text?.count == 0{
            //reset list
            loadItems()
            
            //stop blinking cursor in search bar and dismiss keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
        }
    }
}

