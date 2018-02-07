//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-01-28.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet {
            print(selectedCategory!)
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    //MARK: NUMBER OF ROWS IN SECTION
    //IMPORTANT FUNCTION FOR SETTING NUMBER OF ROWS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    //MARK: SECOND METHOD NEEDED TO LOAD DATA INTO THE CELLS.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {

            
            cell.textLabel?.text = item.title //SETS CELL TO ITEM IN ARRAY
            cell.accessoryType = item.done ? .checkmark : .none  //ADDS CHECK MARK OR OTHER ACCESSORY SPECIAL IF STATMENT HERE
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    //MARK: TABLE VIEW DELEGATES
    //DELEGATE METHOD WHEN A ROW IS SELECTED.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
        
        do {
            try self.realm.write {
                item.done = !item.done
            }
        } catch {
            print("there was an error writing \(error)")
        }
            
        }

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true) //ADD THIS IN TO MAKE IT PRETTIER
    }
    
    //MARK: ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField() //WHEN MAKING AN ALERT TO GRAB TEXT FIELD DATA SET A CONSTANT TO A INSTANCE OF UITEXTFIELD

        //This creates the alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)

        //this creates the action to do and executes once done pressed
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text! //SETTING ENTERED TEXT FIELD TO INSTANCE PROPERTY
                        newItem.dateCreated = NSDate()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("there was an error writing \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
    
        //LOADS TEXR FIELD IN ALERT BUT SEE NOTES ABOVE ABOUT GETTING TEXT FIELD DATA OUT FROM INSIDE CLOSURE
         alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter Item to Add"
                textField = alertTextField  //SETTING VARIBLE TO BE USED OUTSIDE LOCAL SCOPE


        }

        alert.addAction(action)  //ADD THE ALERT TO THE ACTION
        present(alert, animated: true, completion: nil) //PRESENT THE ALERT
    }

    
    //MARK: LOADING DATA
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
        
            do {
                try realm.write {
                realm.delete(item)
                }
                
                } catch {
                 print("There was an error \(error)")
                }
        }
        
    }
    
    


}

//MARK: SEARCH BAR DELEGATE METHODES
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //toDoItems = realm.objects(Item.self).filter(predicate)
        //tableView.reloadData()
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {  //used to hand back to main thread
            searchBar.resignFirstResponder()  //reliquinsh its response and gets rid of cursor and keyboard.

            }
            
        }
    }

}


















