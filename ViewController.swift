//
//  ViewController.swift
//  SecondBelt Exam
//
//  Created by H . on 15/06/1444 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
    }
    

    // MARK: login the User and lead it into homeVC
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text! , password: passwordTextField.text!) { result , error in
//            if error != nil {
                if let error = error, result == nil {
                let alert = UIAlertController(title: "Login in falied", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                print("signin failed")
               
            } else {
                Auth.auth().addStateDidChangeListener() { auth ,user in
                if user != nil{
                    print("\(result!.user.uid)")
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let homeVC = storyBoard.instantiateViewController(withIdentifier: "Home") as! ItemViewController
                    homeVC.userEmail = (result?.user.email)!
                    homeVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: Create new user in firebasee
    @IBAction func signUpButton(_ sender: Any) {
        
        if emailTextField.state.isEmpty == false,
           passwordTextField.state.isEmpty == false{
            print("enter Something")

        } else {
            let email = emailTextField.text
            let password = passwordTextField.text
            Auth.auth().createUser(withEmail: email! , password: password!) { result, error in
            if error != nil {
            self.signUpErrorAlert()
//          print(error)
            } else {
            print("Create user finished")
            self.afterSignUpAlert()
//          print(result)
                }
            }
        }
    }
    
    //MARK: Wrong textFields Values Alert when signUp
    func signUpErrorAlert(){
        let errorAlert = UIAlertController(title: "Something Wrong!!", message: " Make sure you entered email and password successfuly!", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(errorAlert, animated: true)
    }
    
    //MARK: Success SignUp Alert
    func afterSignUpAlert(){
        let succssesAlert = UIAlertController(title: "SignUp Done successfuly!!", message: "You have to close the app first, then open it and login", preferredStyle: .alert)
        succssesAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(succssesAlert, animated: true)
    }
    
    
}



/*
 atteempts
 
 var handle = Auth.auth().addStateDidChangeListener{ auth , user in
     if user == nil {
         self.dismiss(animated: true)
     }
 }
 
 
 */
