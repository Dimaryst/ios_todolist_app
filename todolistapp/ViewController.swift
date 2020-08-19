//
//  ViewController.swift
//  todolistapp
//
//  Created by  Dimary on 13.07.2020.
//  Copyright © 2020  Dimary. All rights reserved.
//  Test Application (iOS Developer tutorial in Skillbox)
//  https://bruno.ph/blog/articles/swift-tutorial-mytodo/ - helped me with
//  persistence

import UIKit

class ViewController: UITableViewController {
    
    var Items = [ToDoItem]()
    let addDialog = UIAlertController(title: "Add new item", message: "Enter the activity you want to schedule:", preferredStyle: .alert)
    let editDialog = UIAlertController(title: "Edit", message: "Edit the activity:", preferredStyle: .alert)
    var selectedRowForEditing: IndexPath? = nil
    var selectedRowEditingSuccess: ((Bool) -> Void)? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My ToDo List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnAddButton))
        addDialog.addTextField(configurationHandler: nil)
        addDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addDialog.addAction(UIAlertAction(title: "Add", style: .default, handler: addNewItem))
        
        editDialog.addTextField(configurationHandler: nil)
        editDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        editDialog.addAction(UIAlertAction(title: "Save", style: .default, handler: editItem))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name:
                UIApplication.didEnterBackgroundNotification, object: nil)
        
        
        do
        {
            // Try to load from persistence
            self.Items = try [ToDoItem].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found, not necesserially an error...")
            }
            else
            {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the to-do items!",
                    preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alert, animated: true, completion: nil)

                NSLog("Error loading from persistence: \(error)")
            }
        }

    }
    
    func addNewItem(action: UIAlertAction)
    {
        let Title = addDialog.textFields?[0].text
        let NewItem = ToDoItem(Title: Title!)
        Items.append(NewItem)
        let Path = IndexPath(row: Items.count - 1, section: 0)
        tableView.insertRows(at: [Path], with: .left)
    }
    
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        do
        {
            try Items.writeToPersistence()
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    
    
    @objc func didTapOnAddButton()
    {
        addDialog.textFields?[0].text = ""
        self.present(addDialog, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_cell", for: indexPath)
         
        let item = Items[indexPath.row]
        cell.textLabel?.text = item.Title
        let accessoryType: UITableViewCell.AccessoryType = item.isCompleted ? .checkmark : .none;
        cell.accessoryType = accessoryType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Items[indexPath.row]
        item.isCompleted = !item.isCompleted
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle : UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action: UIContextualAction, View: UIView, success: @escaping (Bool) -> Void) in
            self.selectedRowForEditing = indexPath
            self.selectedRowEditingSuccess = success
            self.editDialog.textFields?[0].text = self.Items[indexPath.row].Title
            
            self.present(self.editDialog, animated: true)
            
        }
       return UISwipeActionsConfiguration(actions: [action])
    }
    func editItem(action: UIAlertAction)
    {
        let Title = editDialog.textFields?[0].text
        Items[(selectedRowForEditing?.row)!].Title = Title!
        selectedRowEditingSuccess?(true)
        tableView.reloadRows(at: [selectedRowForEditing!], with: .fade)
    }
    
    func saveData() {
        UserDefaults.standard.set(Items, forKey: "ListKey")
        UserDefaults.standard.synchronize()
        
    }
    
    func loadData() {
        if UserDefaults.standard.array(forKey: "ListKey") != nil {
           
        }
    }
}

