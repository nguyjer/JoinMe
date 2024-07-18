//
//  LoginViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 7/18/24.
//

import UIKit

import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailField.placeholder = "Username"
        passwordField.placeholder = "Password"
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                    title: "Sign Up Error",
                    message: "",
                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        //added in order to meet firebases email format
        let username = emailField.text! + ("@JoinMe.com")
        Auth.auth().signIn(withEmail: username, password: passwordField.text!) {
            authResult, error in
            if let error = error as NSError? {
                alert.message = "\(error.localizedDescription)"
                self.present(alert, animated: true)
            }
        }
    }
    
    
//    @IBAction func signupButtonPressed(_ sender: Any) {
//        let alert = UIAlertController(
//            title: "Register",
//            message: "Please register an account with us first",
//            preferredStyle: .alert)
//        
//        alert.addTextField { tfEmail in
//            tfEmail.placeholder = "Please enter your email"
//            
//        }
//        
//        alert.addTextField { tfPassword in
//            tfPassword.isSecureTextEntry = true
//            tfPassword.placeholder = "Please enter your password"
//        }
//    
//        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//            let emailField = alert.textFields![0]
//            let passwordField = alert.textFields![1]
//            
//            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
//                authResult, error in
//                if let error = error as NSError? {
//                    self.errorMessage.text = "\(error.localizedDescription)"
//                } else {
//                    self.errorMessage.text = ""
//                }
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//        
//        
//    }

     
        
    
}
