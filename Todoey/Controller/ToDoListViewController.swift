//
//  ViewController.swift
//  Todoey
//
//  Created by Dustin Prevatt on 12/8/18.
//  Copyright © 2018 Dustin Prevatt. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        print(dataFilePath)
        // Storing data to a file
    }

    //MARK: TableView Datascource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row].title)
        
        
        // itemArray[indexPath.row].setValue(value: Any?, forKey: String) // Example Update Statement
        // context.delete(itemArray[indexPath.row])  // Example Delete Statement
        // Add a checkmark to the cell when it is selected
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Local Variabnle to hold the value of the alertTextField
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What to do when the user clicks the 'Add Item' button
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
//            self.itemArray.append(textField.text!)
            
            // Store using user defualts plist
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Save Items Function
    func saveItems() {
        
        do {
          try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    //MARK: Load Items Method
    func loadItems(request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // This method has a default valuie set
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error making fetch request: \(error)")
        }
        tableView.reloadData()
        
    }
    

    
}

//MARK: - SearchBar Methods
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Sample select statement
        let searchQuery : NSFetchRequest<Item> = Item.fetchRequest()
        
        // NSPredicate is used to construct a select statement
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        searchQuery.predicate = predicate

        // Sort Descriptor is used like an order by
        searchQuery.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request: searchQuery, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // Tells the keybnoad to dismiss
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

