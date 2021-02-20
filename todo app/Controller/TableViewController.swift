//
//  TableViewController.swift
//  todo app
//
//  Created by sadiq qasmi on 16/02/2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController ,UISearchBarDelegate {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todo.plist")
//
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
        getData()
        
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
            
            saveData()
            
            itemArray.append(newItem)
            
            
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
    func getData(){
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do{
           itemArray = try context.fetch(request)

        }catch{
            print(error)
        }
    }
    
}




