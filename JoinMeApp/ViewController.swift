//
//  ViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/9/24.
//

import UIKit
import FirebaseAuth
import CoreData
import SideMenu
import UserNotifications
import EventKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol feed {
    func uploadPost(post: PostClass)
    func acceptAction(in cell: PostTableViewCell)
    func declineAction(in cell: PostTableViewCell)
    func getName(username: String) -> String
    func getImage(username: String) -> UIImage
    func reloadTable()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, feed, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?

    @IBOutlet weak var notiBell: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "postCell"
    var notiCheck = false
    var currentUser: NSManagedObject? // Updated to NSManagedObject
    private var feedList:[PostClass] = []
    private var personalList:[PostClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 250
        let menuItems = [
            (text: "Account", symbol: "person"),
            (text: "Friends List", symbol: "person.2"),
            (text: "Upcoming Events", symbol: "calendar.badge.plus"),
            (text: "Past Events", symbol: "clock.arrow.circlepath"),
            (text: "Settings", symbol: "gear"),
            (text: "Logout", symbol: "arrow.right.square")
        ]
        
        //imported and downloaded side menu package to make a simple side menu pop up from the home screen
        let menu = SideMenuTableViewController(with: menuItems)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = sideMenu

        notiBellCheck(request: false)
    }
    
    //helper function to check on the status of user notifications
    func notiBellCheck(request: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                if request {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
                        granted, error in
                        if granted {
                            self.notiBell.setSymbolImage(UIImage(systemName: "bell.fill")!, contentTransition: .automatic)
                            self.notiCheck = true
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                }
                break
            case .denied:
                self.notiInstruct(onOrOff: "on", request: request)
                break
            case .authorized:
                self.notiInstruct(onOrOff: "off", request: request)
                break
            case .provisional:
                break
            case .ephemeral:
                break
            default:
                break
            }
        }
    }
    
    //helper function to produce notification instructions
    func notiInstruct(onOrOff: String, request: Bool) {
        DispatchQueue.main.sync {
            self.notiBell.setSymbolImage(UIImage(systemName: onOrOff != "on" ? "bell.fill" : "bell")!, contentTransition: .automatic)
            if request {
                let controller = UIAlertController(
                    title: "Turn \(onOrOff) Notifications",
                    message: "To turn \(onOrOff) notications, please go to your Settings application -> JoinMe -> Notification Settings -> Toggle \(onOrOff)",
                    preferredStyle: .actionSheet)
                
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(controller, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadSegue",
           let destination = segue.destination as? UploadPostViewController {
            destination.delegate = self
            destination.currentUser = currentUser
        } else if segue.identifier == "upcomingSegue",
                  let destination = segue.destination as? UpcomingEventsViewController {
            destination.delegate = self
            destination.feedList = feedList
            destination.personalList = personalList
        } else if segue.identifier == "pastSegue",
                  let destination = segue.destination as?
                    PastEventsViewController {
            destination.delegate = self
            destination.feedList = feedList
            destination.personalList = personalList
        } else if segue.identifier == "settingsSegue",
                  let destination = segue.destination as?
                    SettingsViewController {
            destination.currentUser = currentUser
        } else if segue.identifier == "accSegue",
             let destination = segue.destination as?
               AccountViewController {
            destination.currentUser = currentUser
        } else if segue.identifier == "friendsListSegue",
                  let destination = segue.destination as? FriendsListViewController {
            destination.currentUser = currentUser
//            let destination = segue.destination as? FriendsListViewController {
//                    if let user = currentUser, let username = user.value(forKey: "username") as? String {
//                        destination.currentUser = username
//                    }
        } else if segue.identifier == "expandedPostSegue",
                  let destination = segue.destination as?
                    ExpandedPostViewController {
            destination.post = feedList[tableView.indexPathForSelectedRow!.row]
            destination.profilePicture1 = getImage(username: feedList[tableView.indexPathForSelectedRow!.row].username)
            destination.realName = getName(username: feedList[tableView.indexPathForSelectedRow!.row].username)
        } else if segue.identifier == "locationSegue",
                  let destination = segue.destination as? LocationViewController {
            destination.delegate = self
            destination.postList = feedList
            destination.currentUser = currentUser
        }
    }
    
    func didSelectMenuItem(name: String) {
            sideMenu?.dismiss(animated: true)
            switch name {
                case "Account":
                    performSegue(withIdentifier: "accSegue", sender: self)
                    break
                case "Friends List":
                    performSegue(withIdentifier: "friendsListSegue", sender: self)
                    break
                case "Upcoming Events":
                    performSegue(withIdentifier: "upcomingSegue", sender: self)
                    break
                case "Past Events":
                    performSegue(withIdentifier: "pastSegue", sender: self)
                    break
                case "Settings":
                    performSegue(withIdentifier: "settingsSegue", sender: self)
                case "Logout":
                do {
                    //if user is signed in it will sign them out then dismiss the current screen
                    try Auth.auth().signOut()
                    self.dismiss(animated: true)
                } catch {
                    print("Sign out error")
                }
                    break
                default:
                    break
            }
            
        }
    
    //helper function to parse and retrieve name of a specific user
    func getName(username: String) -> String {
        let results = retrieveUsers()
        for user in results {
            if username.lowercased() == (user.value(forKey: "username") as! String).lowercased() {
                return (user.value(forKey: "name") as! String)
            }
        }
        return "John Doe"
    }
    
    //helper function to parse and retrieve profile picture of a specific user
    func getImage(username: String) -> UIImage {
        let results = retrieveUsers()
        for user in results {
            if username.lowercased() == (user.value(forKey: "username") as! String).lowercased() {
                return (user.value(forKey: "picture") as! PictureClass).picture
            }
        }
        return UIImage(named: "GenericAvatar")!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //allows scrollable table cells
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        
        let row = indexPath.row
        
        let currPost = feedList[row]
        
        let usernameNoEmail = currPost.username.replacingOccurrences(of: "@joinme.com", with: "")
        
        //depending on the poster the post table cell will have a different look
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "") == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.eventTitle) at \(currPost.location)"
            cell.hideButtons()
            
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.eventTitle) at \(currPost.location)"
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
            // find post in personalList that corresponds to the selected row in feedList
            let postToDelete = feedList[indexPath.row]
                
            if let indexInPersonalList = personalList.firstIndex(where: { $0.eventIdentifier == postToDelete.eventIdentifier }) {
                // remove from personalList
                personalList.remove(at: indexInPersonalList)
                    
                // remove from calendar
                let eventStore = EKEventStore()
                if let eventToRemove = eventStore.event(withIdentifier: postToDelete.eventIdentifier) {
                    do {
                        try eventStore.remove(eventToRemove, span: .thisEvent)
                    } catch {
                        print("Error removing event: \(error)")
                    }
                }
                feedList.remove(at: indexPath.row)
                // save to Core Data
                updateUser()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currDate = Date()
        
        let results = retrieveUsers()
        for currResult in results {
            //checks to find the current user entity with the current use logged in with firebase Auth
            if let username = currResult.value(forKey: "username") as? String {
                if username.lowercased() == Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                    
                    currentUser = currResult
                    feedList = currResult.value(forKey: "feed") as! [PostClass]
                    personalList = currResult.value(forKey: "accepted") as! [PostClass]
                    break
                }
            }
        }
        feedList = feedList.filter { post in
            currDate < post.endDate
        }
        tableView.reloadData()
    }
    
    // function to clear core data
    func clearCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var fetchedResults: [NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
                saveContext()
            }
        } catch {
            print("Error during deleting data")
            abort()
        }
    }
    
    
    //saves the current entities
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
    
    //retrieves all users
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
    
    //used to keep core data up to data with changes in the feeds for home upcoming and past VC
    func updateUser() {
        currentUser?.setValue(feedList, forKey: "feed")
        currentUser?.setValue(personalList, forKey: "accepted")
        saveContext()
    }
    
    //functions below are bottom and top nav bar press observers
    @IBAction func mapNavButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func notiBellPressed(_ sender: Any) {
        notiBellCheck(request: true)
    }
    
    //all functions below function as delegates
    func uploadPost(post: PostClass) {
        feedList.append(post)
        personalList.append(post)
        updateUser()
    }
    
    func acceptAction(in cell: PostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            personalList.append(feedList[indexPath.row])
            feedList.remove(at: indexPath.row)
            updateUser()
            
            //this queue allows for a delay in the fade delete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                            guard let self = self else { return }
                            tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func declineAction(in cell: PostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            feedList.remove(at: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                            guard let self = self else { return }
                            tableView.deleteRows(at: [indexPath], with: .fade)
            }
            updateUser()
        }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
}

