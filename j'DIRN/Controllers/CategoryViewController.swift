//
//  CategoryViewController.swift
//  j'DIRN -> just, Do It Right Now
//
//  Created by Рахат Султаналиулы on 14.01.2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
            //MARK: - Properties
    private let db = DataModelManager()
    
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = db.getItems(entity: Category.self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
            navigationItem.backButtonTitle = K.categoryTitle
        }
    }
    
    //MARK: - IBAction
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryText = UITextField()
        
        let alertController = UIAlertController(title: K.AlertCategory.title, message: nil, preferredStyle: .alert)
        let tryController = UIAlertController(title: K.WarningAlert.title, message: K.WarningAlert.msg, preferredStyle: .alert)
            tryController.addAction(UIAlertAction(title: "Okay", style: .default))
        let alertAction = UIAlertAction(title: K.AlertCategory.alertAddButton, style: .default) { action in
            if let newCategoryTitle = newCategoryText.text {
                if newCategoryTitle.count != 0 {
                    let newCategory = self.db.newCategory(name: newCategoryTitle)
                    self.categories.append(newCategory)
                    self.tableView.reloadData()
                }
                self.present(tryController, animated: true)
            }
        }
        
        alertController.addAction(alertAction)
        alertController.addTextField() { alertTextField in
            alertTextField.placeholder = K.AlertCategory.txtPlaceholder
            newCategoryText = alertTextField
        }
        
        self.present(alertController, animated: true)
    }
    
}

            //MARK: - TableView Delegate and Data Source
extension CategoryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return K.categoryTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellCategoryId, for: indexPath)
        cell.textLabel!.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.segueGoItems, sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted, \(categories[indexPath.row].name ?? "EMPTY")")
            db.removeItem(from: &categories, at: indexPath.row)
            tableView.reloadData()
        }
    }
}
