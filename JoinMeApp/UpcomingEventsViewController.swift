//
//  UpcomingEventsViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/25/24.
//

import UIKit
import FirebaseAuth

import EventKit
import CoreData

class UpcomingEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! PostTableViewCell
        cell.delegate = self
        
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
            
            for user in 0...personalList[indexPath.row].users.count {
                if personalList[indexPath.row].users[user] == Auth.auth().currentUser!.email!.replacingOccurrences(of: "@joinme.com", with: "") {
                    personalList[indexPath.row].users.remove(at: user)
                }
            }
            remove(Auth.auth().currentUser!.email!.replacingOccurrences(of: "@joinme.com", with: ""))
            personalList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // clear container and then adds updated pizza list to container
        }
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
