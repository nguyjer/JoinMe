//
//  AddFriendViewController.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/12/24.
//

import UIKit
import CoreData

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendsList: [NSObject] = []
    let textCellIdentifier = "inviteCell"
    var currentUser: NSObject?
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("retrieving")
        let fetchedResults = retrieveUsers()
        print("retrieved")
        let userFriends = currentUser?.value(forKey: "friends") as! [String]
        friendsList.append(fetchedResults[0])
        for friend in userFriends {
            for result in fetchedResults {
                if friend == result.value(forKey: "username") as! String {
                    friendsList.append(result)
                }
            }
        }
        print("finished view")
    }
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.row].value(forKey:"username") as! String
        let controller = UIAlertController(title: "Add Friend to this event", message: "Confirm you want to add \(String(describing: friend))", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Add", style: .default, handler:  { _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.textCellIdentifier, for: indexPath) as! FriendsListTableViewCell
            cell.backgroundColor = .lightGray
            let otherVC = self.delegate as! getInfo
            otherVC.inviteFriend(friend: friend)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(controller, animated: true)
        
    }
}
