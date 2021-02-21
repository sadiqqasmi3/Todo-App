//
//  TableViewController.swift
//  todo app
//
//  Created by sadiq qasmi on 16/02/2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Catagory? {
        didSet{
            getData()
        }
    }
    //let defaults = UserDefaults.standard
    
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todo.plist")
//
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let item = defaults.array(forKey: "Todo list") as? [String]{
        //            itemArray = item
        //        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title!)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add your Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            print("working.....")
            
            

            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatagory = selectedCategory
            
            saveData()
            
            itemArray.append(newItem)
            tableView.reloadData()
            
            
        }
        alert.addAction(action)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new item"
            textField = textfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData(){
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func getData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do{
           itemArray = try context.fetch(request)

        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}

extension TableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        getData(with: request , predicate: predicate)
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        getData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}




