//
//  ViewController.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/15/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import UIKit
import RealmSwift

class DuitViewController: SwipeTableViewController{
    
    var duitItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems() //Data array consistent.
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        /* Heigh of the cell's row */
        tableView.rowHeight = 80.0
        
    }
    
    
    /* Tableview Data source */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duitItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Calling the super class */
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "DuitItemCell", for: indexPath)
        
        if let item = duitItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Add a checkmark when the current cell is selected.
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Sin pendientes..."
        }
        
        
        
        return cell
    }
    
    /* Tableview Delegate Methods */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Check is the done value is the oposite of the current row.
        if let item = duitItems?[indexPath.row] {
            do {
                try realm.write {
                    
                    //realm.delete(item)
                    
                    item.done = !item.done
                    
                }
            } catch {
                print("Error saving status data \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            
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
    

    
    /* Load items from Ream */
    func loadItems() {

        duitItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    /* override updateModel fuction */
    override func updateModel(at indexPath: IndexPath) {
        if let item = duitItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }

}

/* Search Bar Methods */
extension DuitViewController: UISearchBarDelegate {

    /* When the search bar is focus */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        duitItems = duitItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    /* When the search bar is unfocus */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
