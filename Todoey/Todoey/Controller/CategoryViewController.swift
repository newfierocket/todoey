//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-02-01.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
       tableView.separatorStyle = .none
        
    }
    
    
    //MARK: TABLE VIEW NUMBER OF ROWS
    //SETS UP NUMBER OF ROWS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
//    MARK: CELL FOR ROW AT INDEX PATH
//    SECOND METHOD NEEDED TO LOAD DATA INTO THE CELLS.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
    
        if let cellColor = categoryArray?[indexPath.row].cellColor {
            guard let backGroundColor = HexColor(cellColor) else { fatalError() }
            cell.backgroundColor = backGroundColor
            cell.textLabel?.textColor = ContrastColorOf(backGroundColor, returnFlat: true)
        } else {
            cell.backgroundColor = UIColor.randomFlat
        }
        
        return cell
    }
    
    
    //MARK: - SAVE DATA
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
            
        }
        
    }
    
    //MARK: LOADING DATA
    func loadData() {
        categoryArray = realm.objects(Category.self)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItem", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            destinationVC.selectedColor = categoryArray?[indexPath.row].cellColor
            
            
        }
    }
    
    
    

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //WHEN MAKING AN ALERT TO GRAB TEXT FIELD DATA SET A CONSTANT TO A INSTANCE OF UITEXTFIELD
        
        //This creates the alert
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        //this creates the action to do and executes once done pressed
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //CREATE AN INSTANCE TO ATTACH TO CORE DATA
            let newCategory = Category()
            newCategory.name = textField.text! //SETTING ENTERED TEXT FIELD TO INSTANCE PROPERTY
            //newCategory.done = false
            newCategory.cellColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category to Add"
            textField = alertTextField  //SETTING VARIBLE TO BE USED OUTSIDE LOCAL SCOPE
            
            }
        
        alert.addAction(action)  //ADD THE ALERT TO THE ACTION
        present(alert, animated: true, completion: nil) //PRESENT THE ALERT
        
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    for item in categoryArray![indexPath.row].items {
                        realm.delete(item)
                    }
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("There was an error deleting item \(error)")
            }
        }
        
    }
    
    
    

}
