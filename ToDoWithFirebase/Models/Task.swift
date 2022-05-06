//
//  Task.swift
//  ToDoWithFirebase
//
//  Created by Sergey on 05.05.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Task {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        
        print("convert succes complited")
        return ["title": title, "userId": userId, "completed": completed]
        
    }
}
