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
    var upcomingList: [PostClass] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        
        // Filter out events that have already passed for display purposes
        let currDate = Date()
        upcomingList = personalList.filter { post in
            currDate < post.endDate
        }
        // Reload the table view to reflect changes
        tableView.reloadData()
    }

        // Updated table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! PostTableViewCell
        cell.delegate = self
            
        let row = indexPath.row
        let currPost = upcomingList[row] // Use upcomingList for display
            
        let usernameNoEmail = currPost.username.replacingOccurrences(of: "@joinme.com", with: "")
        
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "") == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.location)"
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.location)"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedStart = formatter.string(from: currPost.startDate)
        let formattedEnd = formatter.string(from: currPost.endDate)
        
        cell.profilePicture.image = getImage(username: currPost.username)
        cell.dateScheduled.text = "When: \(formattedStart)\nUntil: \(formattedEnd)"
        cell.descriptionLabel.text = currPost.descript
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // find the post in personalList that corresponds to the selected row in upcomingList
            let postToDelete = upcomingList[indexPath.row]
                
            if let indexInPersonalList = personalList.firstIndex(where: { $0.eventIdentifier == postToDelete.eventIdentifier }) {
                // remove from personalList
                personalList.remove(at: indexInPersonalList)
                    
                // remove from feedList
                feedList.removeAll { $0.eventIdentifier == postToDelete.eventIdentifier }
                    
                // remove from calendar
                let eventStore = EKEventStore()
                if let eventToRemove = eventStore.event(withIdentifier: postToDelete.eventIdentifier) {
                    do {
                        try eventStore.remove(eventToRemove, span: .thisEvent)
                    } catch {
                        print("Error removing event: \(error)")
                    }
                }
                    
                // save to Core Data
                let fetchedResults = retrieveUsers()
                for result in fetchedResults {
                    if (result.value(forKey: "username") as! String).lowercased() == Auth.auth().currentUser!.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                        result.setValue(personalList, forKey: "accepted")
                        result.setValue(feedList, forKey: "feed")
                        saveContext()
                        break
                    }
                }
                    
                // Remove from upcomingList and update the table view
                upcomingList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
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
