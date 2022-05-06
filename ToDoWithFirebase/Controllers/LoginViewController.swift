//
//  ViewController.swift
//  ToDoWithFirebase
//
//  Created by Sergey on 05.05.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var identifySegue = "taskSegue"
    var ref: DatabaseReference!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.identifySegue)!, sender: nil)
            }
        }
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.text = ""
        passwordField.text = ""
        
    }
   
    @objc func keyboardDidShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width,
                                                          height: self.view.bounds.height + keyboardFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                          left: 0,
                                                                          bottom: keyboardFrameSize.height,
                                                                          right: 0)
        
    }
    
    @objc func keyboardDidHide() {
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width,
                                                          height: self.view.bounds.height)
    }
    
    func displayWarningLabel(withText text: String) {
        
        warningLabel.text = text
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) { [weak self] in
            
            self?.warningLabel.alpha = 1
        } completion: { [weak self] warningLabel in
            
            self?.warningLabel.alpha = 0
        }

    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        guard let email = emailField.text, let password = passwordField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: (self?.identifySegue)!, sender: nil)
                
            }
            
            self?.displayWarningLabel(withText: "no such user")
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        register()
    }
    
    func register() {
        
        let alertController = UIAlertController(title: "Registration",
                                                message: "Enter your email and password",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { email in
            
            email.placeholder = "Email"
            email.keyboardType = .emailAddress
        }
        
        alertController.addTextField { password in
            
            password.placeholder = "Password"
            password.keyboardType = .default
            password.isSecureTextEntry = true
        }
        
        let okAction = UIAlertAction(title: "Enter", style: .default) { _ in
            guard let email = alertController.textFields?[0].text,
                  let password = alertController.textFields?[1].text,
                  email != "",
                  password != "" else {
                      
                      self.displayWarningLabel(withText: "Info is incorrect")
                      return
                      
                  }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
                
                guard error == nil, user != nil else {
                    print(error!.localizedDescription)
                    return
                }

                let userRef = self?.ref.child("users").child((user?.user.uid)!)
                userRef?.setValue(["email": email])
            }
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
