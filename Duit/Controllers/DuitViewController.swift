//
//  ViewController.swift
//  Duit
//
//  Created by Leonardo Urraza on 3/15/19.
//  Copyright © 2019 Leonardo Grinn. All rights reserved.
//

import UIKit
import CoreData

class DuitViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems() //Data array consistent.
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Call function saveItem
        self.saveItem()
        
        //Delete default graylight.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Add new items */
    @IBAction func AddButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Añade un nuevo pendiente", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Añadir", style: .default) { (action) in
            
            //What will happen once the user clicks the Add item button on the alert button.
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            //Call function saveItem
            self.saveItem()
            
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
    
    /* Model Manipulation Items */
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    /* Load items from core data Item Entity */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }


        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}

/* Search Bar Methods */
extension DuitViewController: UISearchBarDelegate {
    
    /* When the search bar is focus */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        /**/
        loadItems(with: request, predicate: predicate)
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
