//
//  AddNewFriendViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/13/24.
//

//import UIKit
//import FirebaseAuth
//
//class AddNewFriendViewController: UIViewController {
//    
//    @IBOutlet weak var friendUsernameTextField: UITextField!
//    @IBOutlet weak var errorMessageLabel: UILabel!
//    @IBOutlet weak var addButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        errorMessageLabel.isHidden = true
//    }
//    
//    @IBAction func addButtonPressed(_ sender: Any) {
//        guard let username = friendUsernameTextField.text, !username.isEmpty else {
//            errorMessageLabel.text = "Please enter a username"
//            errorMessageLabel.isHidden = false
//            return
//        }
//        
//        let formattedUsername = username + "@joinme.com"
//        
//        // Check if the username exists in Firebase Auth
//        Auth.auth().fetchSignInMethods(forEmail: formattedUsername) { [weak self] signInMethods, error in
//            if let error = error {
//                self?.errorMessageLabel.text = "Error: \(error.localizedDescription)"
//                self?.errorMessageLabel.isHidden = false
//                return
//            }
//            
//            if let signInMethods = signInMethods, !signInMethods.isEmpty {
//                // User exists
//                self?.showUserExistsAlert()
//            } else {
//                // User doesn't exist
//                self?.errorMessageLabel.text = "Sorry, the user doesn't exist"
//                self?.errorMessageLabel.isHidden = false
//            }
//        }
//    }
//    
//    func showUserExistsAlert() {
//        let alert = UIAlertController(
//            title: "User Found",
//            message: "The user exists. They will be added if they also look you up.",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            // Logic to add the user as a friend goes here
//        }))
//        present(alert, animated: true)
//    }
//}

//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class AddNewFriendViewController: UIViewController {
//    
//    @IBOutlet weak var friendUsernameTextField: UITextField!
//    @IBOutlet weak var errorMessageLabel: UILabel!
//    @IBOutlet weak var addButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Any additional setup after loading the view.
//    }
//    
//    @IBAction func addButtonPressed(_ sender: Any) {
//        guard let username = friendUsernameTextField.text, !username.isEmpty else {
//            errorMessageLabel.text = "Username field is empty."
//            return
//        }
//        
//        // Check if the user exists in Firebase Firestore
//        let db = Firestore.firestore()
//        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                self.errorMessageLabel.text = "Error checking user existence."
//            } else {
//                if let documents = querySnapshot?.documents, !documents.isEmpty {
//                    // User exists
//                    self.checkMutualFriendship(user: documents.first)
//                } else {
//                    // User does not exist
//                    self.errorMessageLabel.text = "Sorry, the user doesn't exist."
//                }
//            }
//        }
//    }
//    
//    func checkMutualFriendship(user: QueryDocumentSnapshot?) {
//        // Implement mutual friend check logic here
//        // User can be added if they exist
//        let alert = UIAlertController(title: "User Exists", message: "The user exists and will be added if they also look you up.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
//    }
//}
//import UIKit
//import FirebaseFirestore
//
//class AddNewFriendViewController: UIViewController {
//    
//    @IBOutlet weak var friendUsernameTextField: UITextField!
//    @IBOutlet weak var errorMessageLabel: UILabel!
//    @IBOutlet weak var addButton: UIButton!
//    
//    var currentUser: String = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBAction func addButtonPressed(_ sender: Any) {
//        guard let email = friendUsernameTextField.text, !email.isEmpty else {
//            errorMessageLabel.text = "Username field is empty."
//            return
//        }
//        
//        let username = email.components(separatedBy: "@").first!
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(username).getDocument { (document, error) in
//            if let document = document, document.exists {
//                self.checkMutualFriendship(user: document)
//            } else {
//                self.errorMessageLabel.text = "Sorry, the user doesn't exist."
//            }
//        }
//    }
//    
//    func checkMutualFriendship(user: DocumentSnapshot) {
//        let db = Firestore.firestore()
//        
//        // Add friend to the current user's friends collection
//        db.collection("users").document(currentUser).collection("friends").document(user.documentID).setData(user.data()!) { error in
//            if let error = error {
//                print("Error adding friend: \(error)")
//            } else {
//                let alert = UIAlertController(title: "User Exists", message: "The user exists and will be added if they also look you up.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(alert, animated: true)
//                
//                // Add the current user to the friend's friends collection
//                self.addCurrentUserToFriendsFriendList(friendUID: user.documentID)
//            }
//        }
//    }
//    
//    func addCurrentUserToFriendsFriendList(friendUID: String) {
//        let db = Firestore.firestore()
//        
//        // Fetch the current user's document
//        db.collection("users").document(currentUser).getDocument { (document, error) in
//            if let document = document, document.exists {
//                // Add current user's data to the friend's friends collection
//                db.collection("users").document(friendUID).collection("friends").document(self.currentUser).setData(document.data()!) { error in
//                    if let error = error {
//                        print("Error adding current user to friend's friend list: \(error)")
//                    } else {
//                        print("Successfully added current user to friend's friend list")
//                    }
//                }
//            } else {
//                print("Current user document doesn't exist")
//            }
//        }
//    }
//}
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddNewFriendViewController: UIViewController {
    
    @IBOutlet weak var friendUsernameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var currentUser: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let email = friendUsernameTextField.text, !email.isEmpty else {
            errorMessageLabel.text = "Username field is empty."
            return
        }
        
        let username = email.components(separatedBy: "@").first!
        
        let db = Firestore.firestore()
        db.collection("users").document(username).getDocument { (document, error) in
            if let document = document, document.exists {
                self.checkMutualFriendship(user: document)
            } else {
                self.errorMessageLabel.text = "Sorry, the user doesn't exist."
            }
        }
    }
    
    func checkMutualFriendship(user: DocumentSnapshot) {
        let db = Firestore.firestore()
        
        // Add friend to the current user's friends collection
        db.collection("users").document(currentUser).collection("friends").document(user.documentID).setData([
            "username": user.get("username") as? String ?? "",
            "name": user.get("name") as? String ?? ""
        ]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                let alert = UIAlertController(title: "User Exists", message: "The user exists and will be added if they also look you up.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                // Add the current user to the friend's friends collection
                self.addCurrentUserToFriendsFriendList(friendUID: user.documentID)
            }
        }
    }
    
    func addCurrentUserToFriendsFriendList(friendUID: String) {
        let db = Firestore.firestore()
        
        // Fetch the current user's document
        db.collection("users").document(currentUser).getDocument { (document, error) in
            if let document = document, document.exists {
                // Add current user's data to the friend's friends collection
                db.collection("users").document(friendUID).collection("friends").document(self.currentUser).setData([
                    "username": document.get("username") as? String ?? "",
                    "name": document.get("name") as? String ?? ""
                ]) { error in
                    if let error = error {
                        print("Error adding current user to friend's friend list: \(error)")
                    } else {
                        print("Successfully added current user to friend's friend list")
                    }
                }
            } else {
                print("Current user document doesn't exist")
            }
        }
    }
}
