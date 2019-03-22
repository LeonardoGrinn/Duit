//
//  ViewController.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/15/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import UIKit

class DuitViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Domir"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Comer"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Crisis existencial"
        itemArray.append(newItem3)
        
        //Data array consistent.
//        if let items = defaults.array(forKey: "DuitListArray") as? [String]{
//           itemArray = items
//        }
        
    }
    
    
    /* Tableview Data source */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DuitItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Add a checkmark when the current cell is selected.
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    /* Tableview Delegate Methods */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Check is the done value is the oposite of the current row.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //Delete default graylight.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Add new items */
    @IBAction func AddButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Añade un nuevo pendiente", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Añadir", style: .default) { (action) in
            
            //What will happen once the user clicks the Add item button on the alert button.
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "DuitListArray")
            
            //Reload data in order to update the Array's content.
            self.tableView.reloadData()
        }
        
        
        //Input textfield.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Añade un nuevo pendiente"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

}

