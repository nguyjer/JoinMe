//
//  SignUpViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/18/24.
//

import UIKit
import FirebaseAuth
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var hometownField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows to dismiss keyboard clicking outside
        emailTextField.delegate = self
        numberTextField.delegate = self
        passwordTextField.delegate = self
        userTextField.delegate = self
        confirmTextField.delegate = self
        hometownField.delegate = self
        nameField.delegate = self
    
        emailTextField.autocorrectionType = .no
        numberTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        userTextField.autocorrectionType = .no
        confirmTextField.autocorrectionType = .no
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                //adds user to the core data entity "user"
                self.addUser()
                self.performSegue(withIdentifier: "signUpSegue", sender: self)
                
                //this should blank out all the text fields allowing for another account to be made later
                self.userTextField.text = nil
                self.passwordTextField.text = nil
                self.confirmTextField.text = nil
                self.emailTextField.text = nil
                self.hometownField.text = nil
                self.numberTextField.text = nil
                self.nameField.text = nil
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == numberTextField {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func clearPost() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
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
    }
    
    func clearUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        confirmTextField.placeholder = "Confirm Password"
        emailTextField.placeholder = "Email"
        numberTextField.placeholder = "Number"
        nameField.placeholder = "Name"
        hometownField.placeholder = "Hometown"
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
    
    func addUser() {
        let friends: [String] = []
        let feed: [PostClass] = []
        let accepted: [PostClass] = []
        let userTemp = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        let picture = PictureClass(picture: UIImage(named: "GenericAvatar")!)
        userTemp.setValue(userTextField.text, forKey: "username")
        userTemp.setValue(friends, forKey: "friends")
        userTemp.setValue(feed, forKey: "feed")
        userTemp.setValue(accepted, forKey: "accepted")
        userTemp.setValue(picture, forKey: "picture")
        userTemp.setValue(nameField.text, forKey: "name")
        userTemp.setValue(hometownField.text, forKey: "hometown")
        userTemp.setValue("", forKey: "bio")
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
