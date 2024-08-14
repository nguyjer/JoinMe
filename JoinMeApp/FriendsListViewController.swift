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


//
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
//        performSegue(withIdentifier: "addFriendSegue", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addFriendSegue" {
//            let destinationVC = segue.destination as! AddNewFriendViewController
//            destinationVC.currentUser = currentUser
//        }
//    }
//}

//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    @IBOutlet weak var tableView: UITableView!
//    var friendsList: [NSDictionary] = []
//    var currentUser: String?
//    let textCellIdentifier = "friendsListCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Check if user is logged in
//        if let user = Auth.auth().currentUser {
//            currentUser = user.uid // You can use user.uid (unique identifier) or user.email as needed
//            fetchFriends()
//        } else {
//            print("No user is logged in")
//            // Handle the scenario where no user is logged in
//        }
//    }
//    
//    func fetchFriends() {
//        guard let currentUser = currentUser else {
//            print("Current user is not set")
//            return
//        }
//
//        let db = Firestore.firestore()
//        
//        db.collection("users").document(currentUser).collection("friends").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    self.friendsList.append(document.data() as NSDictionary)
//                }
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
//        
//        let friendData = friendsList[indexPath.row]
//        cell.username.text = friendData["username"] as? String
//        cell.userPersonalName.text = friendData["name"] as? String
//        // Assume picture is being handled with another key like "picture"
//        // cell.profileImage.image = ...
//
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friendsList.count
//    }
//    
//    @IBAction func discoverButtonPressed(_ sender: Any) {
//        performSegue(withIdentifier: "addFriendSegue", sender: self)
//        print("Discover button pressed at \(Date())")
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addFriendSegue" {
//            let destinationVC = segue.destination as! AddNewFriendViewController
//            if let currentUser = currentUser {
//                destinationVC.currentUser = currentUser
//                print("Preparing for segue to AddNewFriendViewController")
//            } else {
//                print("Current user is nil")
//                // Handle the case where currentUser is nil, if necessary
//            }
//        }
//    }
//}

 
import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // Array of dictionaries containing username and name of friends
    var friendsList: [NSDictionary] = []
    var currentUser: String?
    let textCellIdentifier = "friendsListCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if user is logged in
        if let user = Auth.auth().currentUser {
            currentUser = user.uid // You can use user.uid (unique identifier) or user.email as needed
            fetchFriends()
        } else {
            print("No user is logged in")
        }
    }
    
    func fetchFriends() {
        guard let currentUser = currentUser else {
            print("Current user is not set")
            return
        }

        let db = Firestore.firestore()
        
        db.collection("users").document(currentUser).getDocument { (document, error) in
            if let error = error {
                print("Error getting friends list: \(error)")
            } else if let document = document, document.exists {
                self.friendsList = document.get("friendlist") as? [NSDictionary] ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
        
        let friendData = friendsList[indexPath.row]
        cell.username.text = friendData["username"] as? String
        cell.userPersonalName.text = friendData["name"] as? String
        // Assume picture is being handled with another key like "picture"
        // cell.profileImage.image = ...

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    @IBAction func discoverButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addFriendSegue", sender: self)
        print("Discover button pressed at \(Date())")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFriendSegue" {
            let destinationVC = segue.destination as! AddNewFriendViewController
            if let currentUser = currentUser {
                destinationVC.currentUser = currentUser
                print("Preparing for segue to AddNewFriendViewController")
            } else {
                print("Current user is nil")
            }
        }
    }
}
