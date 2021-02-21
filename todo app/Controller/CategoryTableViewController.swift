//
//  CatagoryTableViewController.swift
//  todo app
//
//  Created by sadiq qasmi on 21/02/2021.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoryArray = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }
    
    //MARK: - tableView datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            
            print("checking...")
            
            let newItem = Catagory(context: context)
            newItem.name = textField.text!
            
            saveData()
            
            categoryArray.append(newItem)
            tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new item"
            textField = textfield
        }
        present(alert, animated: true, completion: nil)
        
    }
    func saveData() {
        do{
            try context.save()
            
        }catch{
            print("Error while saving data\(error)")
        }
        tableView.reloadData()
    }
    func getData(with request:NSFetchRequest<Catagory> = Catagory.fetchRequest()) {
        do{
        categoryArray = try context.fetch(request)
    
        }catch{
            print("Error while fetching data \(error)")
        }
        tableView.reloadData()
    }
}
