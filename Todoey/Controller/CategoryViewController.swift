//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dustin Prevatt on 12/15/18.
//  Copyright © 2018 Dustin Prevatt. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories: [Category] = [];
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Local Variabnle to hold the value of the alertTextField
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What to do when the user clicks the 'Add Item' button
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            //            self.itemArray.append(textField.text!)
            
            // Store using user defualts plist
            //            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell;
    }
    
    // MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories[indexPath.row].name!)
        
        // This line will take remove the selected border in the active cell quickly
        // tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // MARK: - Prepare for Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
        //MARK: - Data Manipulation Methods
        func saveCategories() {
            
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
            
            tableView.reloadData()
        }
        
        
        func loadCategories(request : NSFetchRequest<Category> = Category.fetchRequest()) { // This method has a default valuie set
            
            do {
                categories = try context.fetch(request)
            } catch {
                print("Error making fetch request: \(error)")
            }
            tableView.reloadData()
        }
    
}


