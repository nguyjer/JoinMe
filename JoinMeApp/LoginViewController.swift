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
    
    func retrieveUsers() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            if let fetchedResults = try context.fetch(request) as? [NSManagedObject] {
                return fetchedResults
            }
        } catch {
            print("Error occurred while retrieving data: \(error)")
            abort()
        }
        return []
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
}
