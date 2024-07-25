//
//  UpcomingEventsViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/25/24.
//

import UIKit
import FirebaseAuth

class UpcomingEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var delegate: UIViewController!
    var feedList: [PostClass] = []
    var personalList: [PostClass] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for currPosts in feedList {
            if currPosts.users.contains((Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: ""))!) {
                print("added personal")
                personalList.append(currPosts)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! PostTableViewCell
        cell.delegate = self
        
        let row = indexPath.row
        
        let currPost = personalList[row]
        
        let usernameNoEmail = currPost.username.replacingOccurrences(of: "@joinme.com", with: "")
        
        if Auth.auth().currentUser?.email == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.location)"
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.location)"
        }
        
        cell.dateScheduled.text = currPost.date
        cell.descriptionLabel.text = currPost.descript
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
