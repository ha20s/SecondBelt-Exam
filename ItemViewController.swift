//
//  ItemViewController.swift
//  SecondBelt Exam
//
//  Created by H . on 15/06/1444 AH.
//

import UIKit
import Firebase 
import FirebaseAuth

class ItemViewController: UIViewController {
    
    //MARK: vars
    let ref = Database.database().reference(withPath: "Items")
    var items : [Item] = [] // contents of tableView in this variable
    var userEmail = String()
    

    // MARK: Outlets 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView setup
        tableView.dataSource = self
        tableView.delegate = self
        
        // hide back Button
        self.navigationItem.setHidesBackButton(true, animated: true)
        // view title
        title = " Grocery List "
        
        // databse setup
        ref.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
        })
        ref.observe(.value, with: { snapshot in
            var newItem : [Item] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                   let item = Item(snapshot:snapshot){
                    newItem.append(item)
                }
            }
            self.items = newItem
            self.tableView.reloadData()
        })
        
    }
    
    //MARK: add alert
    func addAlert(){
        let itemAlert = UIAlertController(title: "Add the item", message: "", preferredStyle: .alert)
        itemAlert.addTextField{(textField: UITextField!) -> Void in
        textField.placeholder = "What You want from grocery?"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
        let itemTextField = itemAlert.textFields![0] as UITextField
            
            if let item = itemTextField.text {
                
                let newItem = Item(itemName: item,  addedByUser: self.userEmail)
                let addItemRef = self.ref.childByAutoId()
                addItemRef.setValue(newItem.convertToObject())
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        itemAlert.addAction(saveAction)
        itemAlert.addAction(cancelAction)
        
        present(itemAlert, animated: true)
    }
    
    func signOut(){
        
        let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginView = storyboard.instantiateViewController(withIdentifier: "Login")
                loginView.modalPresentationStyle = .fullScreen
                present(loginView, animated: true)
            }
            catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                    }
        print("SignOut Done")
    }
   
    

    @IBAction func infoAction(_ sender: Any) {
        signOut()
    }
    
    @IBAction func addAction(_ sender: Any) {
       addAlert()
    }
}

extension ItemViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let itemObject = items[indexPath.row]
        cell.textLabel?.text = "\(itemObject.itemName)  by  \(itemObject.addedByUser)"
        return cell
    }

    
    //MARK: Edit selected cell
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemID = items[indexPath.row].key
        
        //MARK: edit the item from tableView by swiping 
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
               print("Edit: \(indexPath.row + 1)")
            
        // aler setup
        let itemAlert = UIAlertController(title: "Edit the item", message: "", preferredStyle: .alert)
        itemAlert.addTextField{(textField: UITextField!) -> Void in
        textField.placeholder = "Some Changes?"
        }
            
        let saveAction = UIAlertAction(title: "Save", style: .default)
        { (action) in
        guard let textfiled = itemAlert.textFields?[0] else{
        return
        }
        if let itemUpdated = textfiled.text {
        self.ref.child(itemID).observeSingleEvent(of: .value, with: { (snapshot) in
        let item_ = snapshot.value as! [String: Any]
            let name = item_["itemName"] as! String
        print( "name :\(name)")
        }) { (error) in
        print(error.localizedDescription)
        }
            
            let newItem = Item(itemName: itemUpdated, addedByUser: self.userEmail)
        self.ref.child(itemID).updateChildValues(newItem.convertToObject() as! [AnyHashable : Any])
        self.tableView.reloadData() } else {
        return
        }
        }
            
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        itemAlert.addAction(saveAction)
        itemAlert.addAction(cancelAction)
            
            self.present(itemAlert, animated: true)
            
               completionHandler(true)
             }
             edit.image = UIImage(systemName: "info.circle")
             edit.backgroundColor = .orange
        
        //MARK: Delete Item from tableView by swiping
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("Delete: \(indexPath.row + 1)")
            let deletedItem = self.items[indexPath.row]
            deletedItem.ref?.removeValue()
               completionHandler(true)
             }
             delete.image = UIImage(systemName: "trash")
             delete.backgroundColor = .red
        
        
        let swipe = UISwipeActionsConfiguration(actions: [edit , delete])

             return swipe
    }
    
    
   
}


/*
 
 if already i make the nil user case will dismess by it self with this instruction
 //       try? Auth.auth().signOut()

 
  was use
 
 //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 //        if editingStyle == .delete {
 //            let deletedItem = items[indexPath.row]
 //            deletedItem.ref?.removeValue()
 //        }
 //
 //    }
 
 func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)  {
}
 
 
 when completing the black belt requirments 
 //        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
 //        let userVC = storyBoard.instantiateViewController(withIdentifier: "Users") as! UsersViewController
 //
 //        self.navigationController?.pushViewController(userVC, animated: true)
 */
