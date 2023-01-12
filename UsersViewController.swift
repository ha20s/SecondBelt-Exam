//
//  UsersViewController.swift
//  SecondBelt Exam
//
//  Created by H . on 15/06/1444 AH.
//

// MARK: this view for Black Belt Requirements ... not completed 

import UIKit
import Firebase
import FirebaseAuth

class UsersViewController: UIViewController {
    
    //MARK: vars
    var userID = ""
    var people = [User]()
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        databseReference()
        // tableview setup
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: fetch data from database
    
    func databseReference(){
    }
    
    
    @IBAction func signOutAction(_ sender: Any) {

    }
    
    

}

extension UsersViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let usersObject = people[indexPath.row]
        cell.textLabel?.text = usersObject.email
        return cell
    }
    
    
    
    
}

/*
 //MARK: fetch data from database
 
 func databseReference(){
     var ref : DatabaseReference!
     ref = Database.database().reference()
     ref.child("people").observe(.value) { result , error in
     let currentUser = Auth.auth().currentUser?.uid // current user to compare the useres that wont be with them in the list
         let users = result.value as! NSDictionary
         
         for user in users {
             let userID = "\(user.key)"
             
             if userID != currentUser {
             let userInDB = user.value as! NSDictionary
             let anotherUser = User(email: userInDB["email"] as! String, password: userInDB["password"] as! String, id: "\(user.key)")
             self.people.append(anotherUser)
             }
         }
         DispatchQueue.main.async {
             self.tableView.reloadData()
         }

     }
 }
 */

/*
 //        let firebaseAuth = Auth.auth()
 //            do {
 //                try firebaseAuth.signOut()
 //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //                let loginView = storyboard.instantiateViewController(withIdentifier: "Login")
 //                loginView.modalPresentationStyle = .fullScreen
 //                present(loginView, animated: true)
 //            }
 //            catch let signOutError as NSError {
 //                print("Error signing out: %@", signOutError)
 //                    }
 //        print("SignOut Done")
 */
