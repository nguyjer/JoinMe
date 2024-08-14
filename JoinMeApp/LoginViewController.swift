//
//  LoginViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 7/18/24.
//

import UIKit

import FirebaseAuth
import CoreData

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        clearCoreData()
        emailField.autocorrectionType = .no
        passwordField.autocorrectionType = .no
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    func clearCoreData() {
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var fetchedResults: [NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
                saveContext()
            }
        } catch {
            print("Error during deleting data")
            abort()
        }
        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
                saveContext()
            }
        } catch {
            print("Error during deleting data")
            abort()
        }
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailField.placeholder = "User Email"
        passwordField.placeholder = "Password"
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                    title: "Sign Up Error",
                    message: "",
                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        //added in order to meet firebases email format
        let username = emailField.text! + ("@joinme.com")
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
