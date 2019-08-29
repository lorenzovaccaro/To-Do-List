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
    let items = ["Get eggos", "Find Will", "Save Eleven"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        
        //deselct item so that every item selected isn't grayed out
        tableView.deselectRow(at: indexPath, animated: true)
        
        //add/remove checkmark everytime you press item
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    
    
}

