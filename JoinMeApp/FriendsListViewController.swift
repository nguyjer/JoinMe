////
////  FriendsListViewController.swift
////  JoinMeApp
////
////  Created by Tommy Ly on 8/12/24.
////
//
//import UIKit
//import CoreData
//
//class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    var friendsList: [NSObject]!
//    let textCellIdentifier = "friendsListCell"
//    var currentUser: NSObject?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        let fetchedResults = retrieveUsers()
//        
//        let userFriends = currentUser?.value(forKey: "friends") as! [String]
//        for friend in userFriends {
//            for result in fetchedResults {
//                if friend == result.value(forKey: "username") as! String {
//                    friendsList.append(result)
//                }
//            }
//        }
//    }
//    
//    func retrieveUsers() -> [NSManagedObject] {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        
//        do {
//            if let fetchedResults = try context.fetch(request) as? [NSManagedObject] {
//                return fetchedResults
//            }
//        } catch {
//            print("Error occurred while retrieving data: \(error)")
//            abort()
//        }
//        return []
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
//        cell.delegate = self
//        
//        let row = indexPath.row
//        
//        let currFriend = friendsList[row]
//        
//        let picture1 = currFriend.value(forKey: "picture") as? PictureClass
//        cell.profileImage.image = picture1?.picture
//        cell.userPersonalName.text = currFriend.value(forKey: "name") as? String
//        cell.username.text = currFriend.value(forKey: "username") as? String
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friendsList.count
//    }
//    
//    
//    @IBAction func discoverButtonPressed(_ sender: Any) {
//
//    }
//    
//}




import UIKit
import CoreData

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var friendsList: [NSObject]!
    let textCellIdentifier = "friendsListCell"
    var currentUser: NSObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fetchedResults = retrieveUsers()
        
        let userFriends = currentUser?.value(forKey: "friends") as! [String]
        for friend in userFriends {
            for result in fetchedResults {
                if friend == result.value(forKey: "username") as! String {
                    friendsList.append(result)
                }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
        cell.delegate = self
        
        let row = indexPath.row
        
        let currFriend = friendsList[row]
        
        let picture1 = currFriend.value(forKey: "picture") as? PictureClass
        cell.profileImage.image = picture1?.picture
        cell.userPersonalName.text = currFriend.value(forKey: "name") as? String
        cell.username.text = currFriend.value(forKey: "username") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    
    @IBAction func discoverButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addFriendSegue", sender: self)
    }
    
}



//// Delete friend works
//import UIKit
//import CoreData
//
//class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
//    
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//    // An array of NSManagedObject instances representing the user's friends.
//    var friendsList: [NSManagedObject] = []
//    // An array of all users fetched from Core Data.
//    var allUsers: [NSManagedObject] = []
//    // A string used to identify table view cells.
//    let textCellIdentifier = "friendsListCell"
//    var currentUser: NSManagedObject?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        searchBar.delegate = self
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        insertTestData() // Just testing if we have more users
//        let userCount = countUsers()
//        print("Total number of users: \(userCount)")
//        
//        loadAllUsers()
//        updateFriendsList()
//    }
//    
//    func countUsers() -> Int {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        request.includesSubentities = false
//        
//        do {
//            let count = try context.count(for: request)
//            return count
//        } catch {
//            print("Error occurred while counting users: \(error)")
//            return 0
//        }
//    }
//    
//    func retrieveUsers() -> [NSManagedObject] {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        
//        do {
//            if let fetchedResults = try context.fetch(request) as? [NSManagedObject] {
//                print("Number of users retrieved: \(fetchedResults.count)")
//                return fetchedResults
//            }
//        } catch {
//            print("Error occurred while retrieving data: \(error)")
//        }
//        return []
//    }
//
//    
//    func loadAllUsers() {
//        allUsers = retrieveUsers()
//        print("Loaded users: \(allUsers)")
//    }
//    
//    func updateFriendsList() {
//        friendsList.removeAll()
//        
//        if let userFriends = currentUser?.value(forKey: "friends") as? [String] {
//            for friend in userFriends {
//                if let friendUser = allUsers.first(where: { $0.value(forKey: "username") as? String == friend }) {
//                    friendsList.append(friendUser)
//                }
//            }
//        }
//        tableView.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("Search text: \(searchText)")
//        
//        if searchText.isEmpty {
//            updateFriendsList()
//        } else {
//            friendsList = allUsers.filter { user in
//                guard let username = user.value(forKey: "username") as? String else {
//                    print("Username attribute is not found for user: \(user)")
//                    return false
//                }
//                print("Checking username: \(username)")
//                return username.lowercased().contains(searchText.lowercased())
//            }
//            tableView.reloadData()
//        }
//    }
//
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//    
//    func addFriend(_ friend: NSManagedObject) {
//        let friendUsername = friend.value(forKey: "username") as! String
//        
//        if var friends = currentUser?.value(forKey: "friends") as? [String], !friends.contains(friendUsername) {
//            friends.append(friendUsername)
//            currentUser?.setValue(friends, forKey: "friends")
//            updateFriendsList()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
//        
//        let currFriend = friendsList[indexPath.row]
//        
//        let picture1 = currFriend.value(forKey: "picture") as? PictureClass
//        cell.profileImage.image = picture1?.picture
//        cell.userPersonalName.text = currFriend.value(forKey: "name") as? String
//        cell.username.text = currFriend.value(forKey: "username") as? String
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friendsList.count
//    }
//    
//    // Make random users for testing purposes
//    func insertTestData() {
//        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
//        let user = NSManagedObject(entity: entity, insertInto: context)
//        
//        user.setValue("testuser", forKey: "username")
//        user.setValue("Test User", forKey: "name")
//        user.setValue([], forKey: "friends")
//        
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save test data: \(error)")
//        }
//    }
//    
//    // Swipe to delete friends
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let friendToDelete = friendsList[indexPath.row]
//            
//            if var friends = currentUser?.value(forKey: "friends") as? [String] {
//                if let username = friendToDelete.value(forKey: "username") as? String {
//                    friends.removeAll { $0 == username }
//                    currentUser?.setValue(friends, forKey: "friends")
//                }
//            }
//            
//            context.delete(friendToDelete)
//            saveContext()
//            
//            friendsList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    
//    func sendFriendRequest(to user: NSManagedObject) {
//        guard let fromUser = currentUser else {
//            print("Current user is nil")
//            return
//        }
//        let friendRequestEntity = NSEntityDescription.entity(forEntityName: "FriendRequest", in: context)!
//        let request = NSManagedObject(entity: friendRequestEntity, insertInto: context)
//        
//        request.setValue(fromUser, forKey: "fromUser")
//        request.setValue(user, forKey: "toUser")
//        request.setValue("pending", forKey: "status")
//        
//        saveContext()
//    }
//
//
//    func addFriend(_ fromUser: NSManagedObject, to toUser: NSManagedObject) {
//        if var friends = toUser.value(forKey: "friends") as? [String] {
//            let fromUsername = fromUser.value(forKey: "username") as! String
//            if !friends.contains(fromUsername) {
//                friends.append(fromUsername)
//                toUser.setValue(friends, forKey: "friends")
//            }
//        }
//        saveContext()
//    }
//
//    func acceptFriendRequest(_ request: NSManagedObject) {
//        request.setValue("accepted", forKey: "status")
//        
//        // Add the user to the friends list
//        let fromUser = request.value(forKey: "fromUser") as! NSManagedObject
//        let toUser = request.value(forKey: "toUser") as! NSManagedObject
//        addFriend(fromUser, to: toUser)
//        
//        // Remove the friend request from pending list
//        context.delete(request)
//        saveContext()
//        
//        updateFriendsList()
//    }
//
//    func declineFriendRequest(_ request: NSManagedObject) {
//        request.setValue("declined", forKey: "status")
//        context.delete(request)
//        saveContext()
//        updateFriendsList()
//    }
//    
//    
//    @IBAction func sendRequestButtonPressed(_ sender: UIButton) {
//        let user = friendsList[sender.tag]
//        sendFriendRequest(to: user)
//        // Create an alert to show that the request has been sent
//        let alert = UIAlertController(title: "Request Sent", message: "Friend request has been sent to \(user.value(forKey: "username") as! String).", preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//
//        present(alert, animated: true, completion: nil)
//    }
//    
//
//    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//}
// 

 
