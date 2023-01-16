//
//  DataModelManager.swift
//  j'DIRN -> just, Do It Right Now
//
//  Created by Рахат Султаналиулы on 14.01.2023.
//

import Foundation
import CoreData

protocol ReloadDataDelegate {
    func getCurrentCategory() -> Category           // should get current selected category
}

            //MARK: - Model manipulation methods
class DataModelManager {
    
    var delegate: ReloadDataDelegate?
    
    // method: saving to database
    func saveItems() {
        do {
            try K.context.save()
        } catch {
            print("\n\nHere error while saving data (ITEM) \n\n\(error)")
        }
    }
    
    // method: fetching from database
    // cRud: -> READ method to get all items
    func getItems<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, descr: NSSortDescriptor? = nil) -> Array<T> {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        // if current entity is Item
        if type(of: entity) == Item.Type.self {
            let cat = delegate?.getCurrentCategory()
            
            let categoryPredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", cat!.name!)
            let itemsDescriptor = NSSortDescriptor(key: "number", ascending: true)
            
            if let searchPredicate = predicate, let searchDescriptor = descr {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
                request.sortDescriptors = [itemsDescriptor, searchDescriptor]
            } else {
                request.predicate = categoryPredicate
                request.sortDescriptors = [itemsDescriptor]
            }
        } else {
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        }
        
        do {
            return try K.context.fetch(request)
        } catch {
            print("\n\nHere error while fetching data\n\n\(error)")
        }
        return [T]()
    }
    
    
    // method: deleting from database
    func removeItem<T: NSManagedObject>(from array: inout [T], at: Int) {
        K.context.delete(array[at])
        array.remove(at: at)
        saveItems()
    }
}

            //MARK: - CREATE A new Item
extension DataModelManager {
    // CRUD methods all methods implemented except UPDATE
    // C -> Create
    // R -> Read
    // U -> Update
    // D -> Delete
    
    // here in this extension implemented only Create method, and other ones in DataBaseManager class, because some methods like saving, removing and loading do same things to all entities, however I do not have Update, cause actually I thought this application does not need it...
    
    // method: creating a new item
    func newItem(title: String, into category: Category, num: Int) -> Item {
        let newItem = Item(context: K.context)
        newItem.title = title
        newItem.number = Int32(num)
        newItem.done = false
        newItem.parentCategory = category
        self.saveItems()
        return newItem
    }
}

            //MARK: - CREATE A new Category
extension DataModelManager {
    // method: creating a new item
    func newCategory(name: String) -> Category {
        let newCategory = Category(context: K.context)
        newCategory.name = name
        self.saveItems()
        return newCategory
    }
}
