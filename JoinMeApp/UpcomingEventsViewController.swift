//
//  UpcomingEventsViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/25/24.
//

import UIKit
import FirebaseAuth

import EventKit

class UpcomingEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var delegate: UIViewController!
    var feedList: [PostClass] = []
    var personalList: [PostClass] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        
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
        
        cell.dateScheduled.text = "When: \(currPost.startDate) - \(currPost.endDate)"
        cell.descriptionLabel.text = currPost.descript
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventStore = EKEventStore()
            guard let eventToRemove = eventStore.event(withIdentifier: personalList[indexPath.row].eventIdentifier) else {
                return
            }
            
            do {
                try eventStore.remove(eventToRemove, span: .thisEvent)
            } catch {
                print("error")
            }
            personalList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // clear container and then adds updated pizza list to container
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
