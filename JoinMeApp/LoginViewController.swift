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
                self.checkUserExist(username: (user?.email?.replacingOccurrences(of: "@joinme.com", with: ""))!)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    func checkUserExist(username: String) {
        let friends: [String] = []
        let feed: [PostClass] = []
        let accepted: [PostClass] = []
        let fetchedResults = retrieveUsers()
        for result in fetchedResults {
            if username == result.value(forKey: "username") as! String {
                return
            }
        }
        let userTemp = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        let picture = PictureClass(picture: UIImage(named: "GenericAvatar")!)
        userTemp.setValue(username, forKey: "username")
        userTemp.setValue(friends, forKey: "friends")
        userTemp.setValue(feed, forKey: "feed")
        userTemp.setValue(accepted, forKey: "accepted")
        userTemp.setValue(picture, forKey: "picture")
        userTemp.setValue("John Doe", forKey: "name")
        userTemp.setValue("Austin", forKey: "hometown")
        saveContext()
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
}
