//
//  TasksViewController.swift
//  ToDoWithFirebase
//
//  Created by Sergey on 05.05.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    
    var tasks: [String] = []
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
}
