//
//  AddNewFriendViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/13/24.
//

import UIKit
import CoreData

class AddNewFriendViewController: UIViewController {

    @IBOutlet weak var friendUsernameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    var currentUser: NSManagedObject?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }

    func extractUsername(from email: String) -> String {
        if let atIndex = email.range(of: "@joinme.com")?.lowerBound {
            let username = String(email[..<atIndex])
            return username.lowercased()
        }
        return email.lowercased() // Fallback in case the domain is not found
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        guard let usernameInput = friendUsernameTextField.text, !usernameInput.isEmpty else {
            errorMessageLabel.text = "Please enter a username"
            errorMessageLabel.isHidden = false
            return
        }

        let formattedUsername = extractUsername(from: usernameInput)
        
        // Prevent adding oneself as a friend
            guard let currentUser = currentUser else { return }
            let currentUserUsername = extractUsername(from: currentUser.value(forKey: "username") as! String)
            if formattedUsername == currentUserUsername {
                errorMessageLabel.text = "You cannot add yourself as a friend."
                errorMessageLabel.isHidden = false
                return
            }

        // Check if the username exists in Core Data
        if let friendToAdd = checkIfUserExists(username: formattedUsername) {
            if friendExistsInCurrentUserFriendList(friend: friendToAdd) {
                errorMessageLabel.text = "You are already friends!"
                errorMessageLabel.isHidden = false
            } else {
                showUserExistsAlert(friend: friendToAdd)
            }
        } else {
            errorMessageLabel.text = "No, this user doesn't exist"
            errorMessageLabel.isHidden = false
        }
    }

    func checkIfUserExists(username: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //let formattedUsernameWithDomain = username + "@joinme.com"
        request.predicate = NSPredicate(format: "username ==[c] %@", username)
        
        
        do {
            if let result = try context.fetch(request) as? [NSManagedObject], !result.isEmpty {
                return result.first
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return nil
    }
    
    func friendExistsInCurrentUserFriendList(friend: NSManagedObject) -> Bool {
        guard let currentUser = currentUser else { return false }
        let currentFriends = currentUser.value(forKey: "friends") as? [String] ?? []
        let friendUsername = extractUsername(from: friend.value(forKey: "username") as! String)
        return currentFriends.contains(friendUsername)
    }

    func showUserExistsAlert(friend: NSManagedObject) {
        let alert = UIAlertController(
            title: "Yes, this user exists",
            message: "Now you are friends with each other",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.addFriendToUser(friend: friend)
        }))
        present(alert, animated: true)
    }

    func addFriendToUser(friend: NSManagedObject) {
        guard let currentUser = currentUser else { return }
        
        var currentUserFriends = currentUser.value(forKey: "friends") as? [String] ?? []
        let friendUsername = extractUsername(from: friend.value(forKey: "username") as! String)
        
        currentUserFriends.append(friendUsername)
        currentUser.setValue(currentUserFriends, forKey: "friends")
        
        var friendsFriends = friend.value(forKey: "friends") as? [String] ?? []
        var currentUserUsername = currentUser.value(forKey: "username") as! String
        friendsFriends.append(currentUserUsername)
        friend.setValue(friendsFriends, forKey: "friends")
        
        
        saveContext()

        checkIfCurrentUserExistsInFriendsList(of: friend)
    }

    func checkIfCurrentUserExistsInFriendsList(of friend: NSManagedObject) {
        let friendFriendsList = friend.value(forKey: "friends") as? [String] ?? []
        
        if friendFriendsList.contains(extractUsername(from: currentUser?.value(forKey: "username") as! String)) {
            print("Friendship confirmed! You are now friends.")
            updateFriendList(for: friend)
        } else {
            print("Friend added, but not yet mutual. Waiting for them to add you.")
        }
    }

    func updateFriendList(for friend: NSManagedObject) {
        var friendFriendsList = friend.value(forKey: "friends") as? [String] ?? []
        
        friendFriendsList.append(extractUsername(from: currentUser?.value(forKey: "username") as! String))
        friend.setValue(friendFriendsList, forKey: "friends")
        
        saveContext()
        self.navigationController?.popViewController(animated: true)
    }

    func saveContext() {
        do {
            try context.save()
            print("Changes saved to Core Data.")
        } catch {
            print("Failed to save changes to Core Data: \(error)")
        }
    }
}

