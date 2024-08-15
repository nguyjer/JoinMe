////
////  FriendsListViewController.swift
////  JoinMeApp
////
////  Created by Tommy Ly on 8/12/24.
////
//
import UIKit
import CoreData

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var friendsList: [NSManagedObject] = []
    let textCellIdentifier = "friendsListCell"
    var currentUser: NSManagedObject?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadFriendsList()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFriendsList()
        tableView.reloadData()
    }
    
    func extractUsername(from email: String) -> String {
        if let atIndex = email.range(of: "@joinme.com")?.lowerBound {
            let username = String(email[..<atIndex])
            return username.lowercased()
        }
        return email.lowercased() // Fallback in case the domain is not found
    }

    func loadFriendsList() {
        guard let currentUser = currentUser else { return }
        
        if let userFriends = currentUser.value(forKey: "friends") as? [String] {
            let formattedUsernames = userFriends.map { extractUsername(from: $0) }
            
            friendsList = retrieveUsers(for: formattedUsernames)
            // Remove the current user from the friends list if present
            if let currentUserEmail = currentUser.value(forKey: "username") as? String {
                let currentUserFormatted = extractUsername(from: currentUserEmail)
                friendsList.removeAll { friend in
                    let friendUsername = extractUsername(from: friend.value(forKey: "username") as? String ?? "")
                    return friendUsername == currentUserFormatted
                }
            }
        }
    }
    
    func retrieveUsers(for usernames: [String]) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "username IN %@", usernames)
        
        do {
            var finalResults = [NSManagedObject]()
            if let fetchedResults = try context.fetch(request) as? [NSManagedObject] {
                
                for buddy in fetchedResults {
                    
                    var buddyUser = buddy.value(forKey: "username") as? String ?? ""
                    var buddyUserLower = buddyUser.lowercased()
                    
                    if usernames.contains(buddyUserLower) {
                        finalResults.append(buddy)
                    }
                    
                }

                return finalResults
            }
        } catch {
            print("Error occurred while retrieving data: \(error)")
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
        
        let currFriend = friendsList[indexPath.row]
        
        let picture1 = currFriend.value(forKey: "picture") as? PictureClass
        cell.profileImage.image = picture1?.picture
        cell.userPersonalName.text = currFriend.value(forKey: "name") as? String
        let tempUsername = currFriend.value(forKey: "username") as? String
        cell.username.text = tempUsername
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }

    // Enable deletion of a friend
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friendToDelete = friendsList[indexPath.row]
            
            // Remove the friend from the local data source
            friendsList.remove(at: indexPath.row)
            
            guard let currentUser = currentUser else { return }
            
            // Update the currentUser's friends list in Core Data
            if var currentUserFriends = currentUser.value(forKey: "friends") as? [String],
               let friendEmail = friendToDelete.value(forKey: "username") as? String {
                
                let formattedUsername = extractUsername(from: friendEmail)
                currentUserFriends.removeAll { $0.lowercased() == formattedUsername }
                currentUser.setValue(currentUserFriends, forKey: "friends")
            }
            
            // Update the friend's list to remove the current user
            if var friendFriends = friendToDelete.value(forKey: "friends") as? [String],
               let currentUserEmail = currentUser.value(forKey: "username") as? String {
                
                let formattedCurrentUser = extractUsername(from: currentUserEmail)
                friendFriends.removeAll { $0.lowercased() == formattedCurrentUser }
                friendToDelete.setValue(friendFriends, forKey: "friends")
            }
            
            // Save the context to persist changes in Core Data
            saveContext()
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }


    func saveContext() {
        do {
            try context.save()
            print("Changes saved to Core Data.")
        } catch {
            print("Failed to save changes to Core Data: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFriendSegue" {
            let destinationVC = segue.destination as! AddNewFriendViewController
            destinationVC.currentUser = currentUser
        } else if segue.identifier == "expandFriendSegue", let destination = segue.destination as? ExpandedFriendsViewController {
            destination.currentFriend = friendsList[tableView.indexPathForSelectedRow!.row]
        }
    }
}

