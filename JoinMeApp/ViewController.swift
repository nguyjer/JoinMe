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

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol feed {
    func uploadPost(post: PostClass)
    func acceptAction(in cell: PostTableViewCell)
    func declineAction(in cell: PostTableViewCell)
    func getName(username: String) -> String
    func getImage(username: String) -> UIImage
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, feed, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?

    @IBOutlet weak var notiBell: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "postCell"
    var notiCheck = false
//    var currentUser: NSObject?
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
        let menu = SideMenuTableViewController(with: menuItems)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        
        sideMenu?.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        notiBellCheck(request: false)

    }
    
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
//                  let destination = segue.destination as? FriendsListViewController {
//            destination.currentUser = currentUser
            let destination = segue.destination as? FriendsListViewController {
                    if let user = currentUser, let username = user.value(forKey: "username") as? String {
                        destination.currentUser = username
                    }
        } else if segue.identifier == "expandedPostSegue",
                  let destination = segue.destination as?
                    ExpandedPostViewController {
            destination.post = feedList[tableView.indexPathForSelectedRow!.row]
            destination.profilePicture1 = getImage(username: feedList[tableView.indexPathForSelectedRow!.row].username)
            destination.name = getName(username: feedList[tableView.indexPathForSelectedRow!.row].username)
        } else if segue.identifier == "locationSegue",
                  let destination = segue.destination as? LocationViewController {
            destination.delegate = self
            destination.postList = feedList
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
                    // you have to dismiss the opened menu before trying to dismiss current view
//                    sideMenu?.dismiss(animated: true)
                    self.dismiss(animated: true)
                } catch {
                    print("Sign out error")
                }
                    break
                default:
                    break
            }
            
        }
    
    func getName(username: String) -> String {
        let results = retrievePosts()
        for user in results {
            if username == user.value(forKey: "username") as! String {
                return (user.value(forKey: "name") as! String)
            }
        }
        return ""
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
        
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "") == currPost.username {
            cell.usernameInvite.text = "You invited others for\n \(currPost.location)"
            cell.hideButtons()
            
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for\n \(currPost.location)"
        }
        cell.profilePicture.image = getImage(username: currPost.username)
        cell.dateScheduled.text = "When: \(currPost.startDate) - \(currPost.endDate)"
        cell.descriptionLabel.text = currPost.descript
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let results = retrievePosts()
        for currResult in results {
            print("inside")
            if let username = currResult.value(forKey: "username") as? String {
                print("passed")
                print(username)
                
                if username.lowercased() == Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                    print("wtf")
                    currentUser = currResult
                    feedList = currResult.value(forKey: "feed") as! [PostClass]
                    personalList = currResult.value(forKey: "accepted") as! [PostClass]
                    break
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("\(indexPath.row)")
            feedList.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            updateUser()
            
        } else if editingStyle == .insert {
        }
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
    
    
    func updateUser() {
        currentUser?.setValue(feedList, forKey: "feed")
        currentUser?.setValue(personalList, forKey: "accepted")
        saveContext()
    }
    
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
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUser()
        }
    }
    
    @IBAction func mapNavButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func notiBellPressed(_ sender: Any) {
//       RIGHT NOW THEWRE IS AN ERORR IDK 
        notiBellCheck(request: true)
    }
    
}

