//
//  PastEventsViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/29/24.
//

import UIKit
import FirebaseAuth
import CoreData

class PastEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: UIViewController!
    var feedList: [PostClass] = []
    var personalList: [PostClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandedPastSegue",
                  let destination = segue.destination as?
            ExpandedPostViewController, let otherVC = delegate as? feed {
            destination.post = personalList[tableView.indexPathForSelectedRow!.row]
            destination.profilePicture1 = otherVC.getImage(username: personalList[tableView.indexPathForSelectedRow!.row].username)
            destination.realName = otherVC.getName(username: personalList[tableView.indexPathForSelectedRow!.row].username)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastCell", for: indexPath) as! PostTableViewCell
        cell.delegate = self
        
        let tempList = personalList.reversed()
        
        let row = indexPath.row
        
        let currPost = personalList[row]
        
        let usernameNoEmail = currPost.username.replacingOccurrences(of: "@joinme.com", with: "")
        
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "") == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.location)"
            
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.location)"
        }
        cell.profilePicture.image = getImage(username: currPost.username)
        cell.dateScheduled.text = "When: \(currPost.startDate) - \(currPost.endDate)"
        cell.descriptionLabel.text = currPost.descript
        return cell
    }
    
    func getImage(username: String) -> UIImage {
        let results = retrievePosts()
        for user in results {
            if username == user.value(forKey: "username") as! String {
                return (user.value(forKey: "picture") as! PictureClass).picture
            }
        }
        return UIImage(named: "GenericAvatar")!
    }
    
    func retrievePosts() -> [NSManagedObject] {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
