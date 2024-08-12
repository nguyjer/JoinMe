//
//  FriendsListViewController.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/12/24.
//

import UIKit
import CoreData

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
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

}
