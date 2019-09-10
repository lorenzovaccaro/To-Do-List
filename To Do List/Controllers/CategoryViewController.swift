//
//  CategoryViewController.swift
//  To Do List
//
//  Created by Lorenzo Vaccaro on 9/9/19.
//  Copyright © 2019 Lorenzo Vaccaro. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //MARK:- Global Variables
    var categoryArray   = [Category]()
    let dataFilePath    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context         = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK:- Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name!
        
        return cell
        
    }
    
    
    //MARK:- Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    //MARK:- Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //set up textfield for alert
        var textField : UITextField = UITextField()
        
        //prompt user to input
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            //create category object
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            //add to array
            self.categoryArray.append(newCategory)
            
            //save item
            self.saveCategories()
            
            //reload tableview
            self.tableView.reloadData()
        }
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create new category"
            textField = UITextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Data Manipulation Methods
    
    func saveCategories(){
        do{
            try self.context.save()
        } catch{
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        } catch{
            print("Error loading data: \(error)")
        }
        
        tableView.reloadData()
    }
    


}
