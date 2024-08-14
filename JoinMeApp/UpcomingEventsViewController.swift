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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandedUpcomingSegue",
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
            for post in 0...feedList.count {
                if feedList[post].eventIdentifier == personalList[indexPath.row].eventIdentifier {
                    feedList.remove(at: post)
                    break
                }
            }
            
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
                if personalList[indexPath.row].users[user].lowercased() == Auth.auth().currentUser!.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                    personalList[indexPath.row].users.remove(at: user)
                    personalList.remove(at: indexPath.row)
                    let fetchedResults = retrieveUsers()
                    for result in fetchedResults {
                        if (result.value(forKey: "username") as! String).lowercased() == Auth.auth().currentUser!.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                            result.setValue(personalList, forKey: "accepted")
                            result.setValue(feedList, forKey: "feed")
                            saveContext()
                            break
                        }
                    }
                    break
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getImage(username: String) -> UIImage {
        let results = retrieveUsers()
        for user in results {
            if username == user.value(forKey: "username") as! String {
                return (user.value(forKey: "picture") as! PictureClass).picture
            }
        }
        return UIImage(named: "GenericAvatar")!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
