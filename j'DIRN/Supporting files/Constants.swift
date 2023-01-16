//
//  Constants.swift
//  j'DIRN -> just Do It Right Now
//  File contains all constants...
//  Created by Рахат Султаналиулы on 11.01.2023.
//

import UIKit

struct K {
    // Context to making CRUD operations or just manipulations with data
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let appName = "j'DIRN"                       // application name
    static let categoryTitle = "Categories"             // title of Main Page
    static let cellCategoryId = "CategoryCell"          // Cell id for Table View to use in main page
    static let cellItemId = "TodoItemCell"              // Cell id fot Table View to use in items page
    static let segueGoItems = "GoItems"                 // Segue Key to perform transition from main to items page
    static let cellNibName = "ItemTableCell"            // Name of custom CellView for table view in items page
    
    // Names of colors which used for this app
    struct AppColors {
        static let darkColor = "AppCHigh"
        static let dorkColor = "AppCSecond"
        static let lightColor = "AppCLight"
        static let lowColor = "AppCLow"
    }
    
    struct AlertCategory {
        static let title = "Add New Category!"
        static let alertAddButton = "Add Category"
        static let txtPlaceholder = "What category do you want to add?"
    }
    
    struct WarningAlert {
        static let title = "Ooops!"
        static let msg = "Field is empty! Please, try again."
    }
    
    struct AlertItems {
        static let title = "Add New Todo Item!"
        static let alertAddButton = "Add Item"
        static let txtPlaceholder = "What do you want to add to this category?"
    }
}
