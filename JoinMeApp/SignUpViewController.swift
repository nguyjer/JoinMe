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
    @IBOutlet weak var hometownField: UITextField!
    @IBOutlet weak var nameField: UITextField!
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
                self.addUser(username: self.userTextField.text!, name:self.nameField.text!, hometown: self.hometownField.text!)
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
        nameField.placeholder = "Name"
        hometownField.placeholder = "HomeTown"
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                    title: "Sign Up Error",
                    message: "",
                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        print("name and hometown")
        print(self.hometownField.text!)
        print(self.nameField.text!)
        
        if passwordTextField.text != confirmTextField.text {
            alert.message = "Unsuccesful Sign Up: Password's do not match"
            present(alert, animated: true)
            return
        }
        //appends an @ domain to comply with firebase template
        let username = userTextField.text! + ("@joinme.com")
        
        if nameField.text == "" {
            alert.message = "Unsuccesful Sign Up: Name is empty"
            present(alert, animated: true)
            return
        }
        
        if hometownField.text == "" {
            alert.message = "Unsuccesful Sign Up: HomeTown is empty"
            present(alert, animated: true)
            return
        }
        
        
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
    
    func addUser(username: String, name:String, hometown:String) {
        var friends: [String] = []
        var feed: [PostClass] = []
        var accepted: [PostClass] = []
        let userTemp = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        let picture = PictureClass(picture: UIImage(named: "GenericAvatar")!)
        userTemp.setValue(username, forKey: "username")
        userTemp.setValue(friends, forKey: "friends")
        userTemp.setValue(feed, forKey: "feed")
        userTemp.setValue(accepted, forKey: "accepted")
        userTemp.setValue(picture, forKey: "picture")
        userTemp.setValue(name, forKey: "name")
        userTemp.setValue(hometown, forKey: "hometown")
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
}
