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
    var pastList: [PostClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        let currDate = Date()
        for post in personalList {
            if currDate >= post.endDate {
                pastList.append(post)
            }
        }
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
        pastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastCell", for: indexPath) as! PostTableViewCell
        cell.delegate = self
        
        let row = indexPath.row
        
        let currPost = pastList[row]
        
        let usernameNoEmail = currPost.username.replacingOccurrences(of: "@joinme.com", with: "")
        
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "") == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.location)"
            
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.location)"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let formattedStart = formatter.string(from: currPost.startDate)
        let formattedEnd = formatter.string(from: currPost.endDate)
        
        cell.profilePicture.image = getImage(username: currPost.username)
        cell.dateScheduled.text = "When: \(formattedStart)\nUntil: \(formattedEnd)"
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
