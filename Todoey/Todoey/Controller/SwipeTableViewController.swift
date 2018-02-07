//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-02-06.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

     

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }


    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        //deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
   
    
    func updateModel(at indexPath: IndexPath) {
        
        
    }



    
}
