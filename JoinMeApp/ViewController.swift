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

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol feed {
    func uploadPost(post: PostClass)
    func acceptAction(in cell: PostTableViewCell)
    func declineAction(in cell: PostTableViewCell)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, feed, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?

    @IBOutlet weak var notiBell: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "postCell"
    var notiCheck = false
    var currentUser: NSObject?
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
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadSegue",
           let destination = segue.destination as? UploadPostViewController {
            destination.delegate = self
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
   }
    }
    
    func didSelectMenuItem(name: String) {
            sideMenu?.dismiss(animated: true)
            switch name {
                case "Account":
                    performSegue(withIdentifier: "accSegue", sender: self)
                    break
                case "Friends List":
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
        
        if Auth.auth().currentUser?.email == currPost.username {
            cell.usernameInvite.text = "You invited others for \(currPost.location)"
            cell.hideButtons()
            
        } else {
            cell.usernameInvite.text = "\(usernameNoEmail) invited others for \(currPost.location)"
        }
        
        cell.dateScheduled.text = currPost.date
        cell.descriptionLabel.text = currPost.descript
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! PostTableViewCell
//        
//        if cell.hid {
//            return 200
//        }
//        
//        return 250 // Default height for other cells
//    }
    
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
//    func clearCoreData() {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        var fetchedResults: [NSManagedObject]
//        
//        do {
//            try fetchedResults = context.fetch(request) as! [NSManagedObject]
//            
//            if fetchedResults.count > 0 {
//                for result:AnyObject in fetchedResults {
//                    context.delete(result as! NSManagedObject)
//                }
//                saveContext()
//            }
//        } catch {
//            print("Error during deleting data")
//            abort()
//        }
//    }
    
    
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
        let fetched = retrievePosts()
        for user in fetched {
            print("looking")
            if let username = user.value(forKey: "username") as? String {
                print("part")
                if username.lowercased() == Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() {
                    print("found")
                    user.setValue(feedList, forKey: "feed")
                    user.setValue(personalList, forKey: "accepted")
                    print("saved")
                    break
                }
            }
        }
        
        saveContext()
    }
    
    func uploadPost(post: PostClass) {
        feedList.append(post)
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
        if !notiCheck {
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
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CalendarSegueIdentifier", sender: self)
        
    }
    
}

