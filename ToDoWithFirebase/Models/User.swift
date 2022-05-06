//
//  User.swift
//  ToDoWithFirebase
//
//  Created by Sergey on 05.05.2022.
//

import Foundation
import Firebase

struct NewUser {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
        
    }
}
