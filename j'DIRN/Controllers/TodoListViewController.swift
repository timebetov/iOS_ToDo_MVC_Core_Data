//
//  ViewController.swift
//  j'DIRN -> just, Do It Right Now
//
//  Created by Рахат Султаналиулы on 11.01.2023.
//
//  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
            //MARK: - Properties
    // initializing model to work with
    private var db = DataModelManager()
    
    // array of Items for working with table cells
    private var itemArray = [Item]()
    
    
    var selectedCategory : Category? {
        didSet {
            db.delegate = self
            self.itemArray = self.db.getItems(entity: Item.self)     // getting data from database
        }
    }

    // loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavigationTitle - Title of current page in the top of screen
        self.title = selectedCategory?.name
        // Setting other own cell view
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellItemId)
    }
    
    // method for refreshing numbers from items
    func refreshData() {
        for (i, item) in itemArray.enumerated() {
            item.setValue(i + 1, forKey: "number")
        }
        tableView.reloadData()
    }
    
    
    
            //MARK: - IBAction (Interface Builder Action)
    
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        // initializing a textField to get text from the AlertController, or just to get title for todo item
        var newItemText = UITextField()
        
        // initializing AlertControllers
        let alertController = UIAlertController(title: K.AlertItems.title, message: nil, preferredStyle: .alert)
        let warningController = UIAlertController(title: K.WarningAlert.title, message: K.WarningAlert.msg, preferredStyle: .actionSheet)
        
        // initializing AlertAction ...
        alertController.addAction(UIAlertAction(title: K.AlertItems.alertAddButton, style: .default) { _ in
            // unwrapping by checking for nil and for existing symbols in field
            guard let titleOfitem = newItemText.text, titleOfitem.count != 0
            else { return self.present(warningController, animated: true) }     // else will be showed Warning Controller
            
            // if there is no problem, new item will be created and return for adding to itemArray
            let newItem = self.db.newItem(title: titleOfitem, into: self.selectedCategory!, num: self.itemArray.count + 1)
            self.itemArray.append(newItem)
            self.tableView.reloadData()
        })
        
        // warning: try again to add a new item method
        warningController.addAction(UIAlertAction(title: "Retry!", style: .default) { _ in
            self.present(alertController, animated: true)
        })
        // warning: canceling the adding a new item method
        warningController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        // adding to ALERT CONTROLLER
        alertController.addTextField() { alertTextField in
            alertTextField.placeholder = K.AlertItems.txtPlaceholder
            newItemText = alertTextField
        }
        
        // showing up ALERT CONTROLLER
        present(alertController, animated: true)
    }
}


            //MARK: - UITableViewDataSource and Delegate

extension TodoListViewController {
    // Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Title For Head In Section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ITEMS"
    }
    // numbersOfRowsInSection - amount of rows that will be in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // cellForRowAt - data for rows (eg. text and etc.) that will be show up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellItemId, for: indexPath) as! ItemTableCell
        let item = itemArray[indexPath.row]
        cell.label.text = item.title
        cell.itemNumber.text = String(item.number)
        cell.accessoryType = item.done ? .checkmark : .none
        cell.backgroundColor = item.done ? UIColor(named: K.AppColors.dorkColor) : .systemBackground
        return cell
    }
    
    // didSelectRowAt - row which touched by user, method for manipulation when user touched current row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.db.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    // commit forRowAt - row that will be deleted | swipe left and remove
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted, \(itemArray[indexPath.row].title ?? "EMPTY")")
            db.removeItem(from: &itemArray, at: indexPath.row)
            self.refreshData()
        }
    }
}


            //MARK: - SearchBar Delegate and ReloadData Delegate

extension TodoListViewController: UISearchBarDelegate, ReloadDataDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let descriptor = NSSortDescriptor(key: "title", ascending: true)
         
        self.itemArray = db.getItems(entity: Item.self, predicate: predicate, descr: descriptor)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.itemArray = db.getItems(entity: Item.self)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            tableView.reloadData()
        }
    }
    
    func getCurrentCategory() -> Category {
        return selectedCategory!
    }
}
