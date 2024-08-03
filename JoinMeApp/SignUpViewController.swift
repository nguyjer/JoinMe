//
//  SignUpViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/18/24.
//

import UIKit
import FirebaseAuth
import CoreData

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.autocorrectionType = .no
        
        numberTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        userTextField.autocorrectionType = .no
        confirmTextField.autocorrectionType = .no
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "signUpSegue", sender: self)
                
                self.userTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        confirmTextField.placeholder = "Confirm Password"
        emailTextField.placeholder = "Email"
        numberTextField.placeholder = "Number"
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                    title: "Sign Up Error",
                    message: "",
                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if passwordTextField.text != confirmTextField.text {
            alert.message = "Unsuccesful Sign Up: Password's do not match"
            present(alert, animated: true)
            return
        }
        //appends an @ domain to comply with firebase template
        let username = userTextField.text! + ("@JoinMe.com")
        Auth.auth().createUser(withEmail: username, password: passwordTextField.text!) {
            authResult, error in
            if let error = error as NSError? {
                alert.message = "\(error.localizedDescription)"
                self.present(alert, animated: true)
                
                
            }
        }
    }

    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func addUser(username: String) {
        var friends: [String] = []
        var feed: [PostClass] = []
        var accepted: [PostClass] = []
        let userTemp = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        userTemp.setValue(username, forKey: "username")
        userTemp.setValue(friends, forKey: "friends")
        userTemp.setValue(feed, forKey: "feed")
        userTemp.setValue(accepted, forKey: "accepted")
        saveContext()
    }
    
    //saves the current entities
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
    
    func retrievePosts() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occurred while retrieving data")
            abort()
        }
        return (fetchedResults)!
    }
    
}
