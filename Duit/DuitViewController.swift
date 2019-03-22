//
//  ViewController.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/15/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import UIKit

class DuitViewController: UITableViewController {
    
    let itemArray = ["Dormir", "Leer", "Crisis existencial"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    /* Tableview Data source */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DuitItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    /* Tableview Delegate Methods */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //Add a checkmark when the current cell is selected.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //Delete default graylight.
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

