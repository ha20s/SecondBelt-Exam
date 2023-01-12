//
//  DataModel.swift
//  SecondBelt Exam
//
//  Created by H . on 15/06/1444 AH.
//

import Foundation
import Firebase

struct User {
//    let ref : DatabaseReference?
    let email : String
    let password : String
    let id : String
    
    init(email: String, password: String, id: String) {
        self.email = email
        self.password = password
        self.id = id
    }
}

struct Item {
   let ref : DatabaseReference? // copy the data that already existed in the database
   let key : String
   var itemName : String
   let addedByUser : String // i used it in the table view , so it has to be linked the email of user
    
    init(itemName: String, key : String = "" , addedByUser : String) {
        self.ref = nil
        self.key = key
        self.itemName = itemName
        self.addedByUser = addedByUser
    }
    
    init?(snapshot: DataSnapshot){

        guard
          let value = snapshot.value as? [String: AnyObject],
          let itemName = value["itemName"] as? String ,
          let addedByUser = value["addedByUser"] as? String
        else { return nil }

        self.ref = snapshot.ref
        self.key = snapshot.key
        self.itemName = itemName
        self.addedByUser = addedByUser
    }
    
    
    func convertToObject() -> Any {
        return [
            "itemName" : itemName ,
            "addedByUser" : addedByUser
        ]
    }
}

