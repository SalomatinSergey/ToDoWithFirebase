//
//  TasksViewController.swift
//  ToDoWithFirebase
//
//  Created by Sergey on 05.05.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    
    var user: NewUser!
    var ref: DatabaseReference?
    var tasks = Array<Task>()
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let currentUser = Auth.auth().currentUser else { return }

        user = NewUser(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref?.observe(.value, with: { [weak self] snapshot in
            
            var emptyTasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                emptyTasks.append(task)
            }
            
            self?.tasks = emptyTasks
            self?.tableViewOutlet.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        ref?.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    @IBAction func signOutBitton(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }

        dismiss(animated: true)
    }
    
    @IBAction func addTaskButton(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "New task", message: "add new task", preferredStyle: .alert)
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textfield = alertController.textFields?.first, textfield.text != "" else { return }
            let task = Task(title: textfield.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref?.child(task.title.lowercased())
            taskRef!.setValue(task.convertToDictionary())
            print("okok")
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        let isCompleted = task.completed
        cell.textLabel?.text = taskTitle
        toggleCompletion(cell, isCompleted: isCompleted)
        
        return cell
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
}
