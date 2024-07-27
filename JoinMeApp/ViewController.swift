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
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, feed, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "postCell"
    
    var feedList:[PostClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 200
        let menu = SideMenuTableViewController(with: ["Location",
                                                  "Friends list",
                                                  "Upcoming Events",
                                                  "Past Events",
                                                  "Settings",
                                                   "Logout"])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        
        sideMenu?.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        let results = retrievePosts()
        for currResult in results {
            if let username = currResult.value(forKey: "username"), let location = currResult.value(forKey: "location"), let description = currResult.value(forKey: "descript"), let date = currResult.value(forKey: "date"), let users = currResult.value(forKey: "users") {
                feedList.append(PostClass(username: username as! String, location: location as! String, descript: description as! String, date: date as! String, users: users as! [String]))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadSegue",
           let destination = segue.destination as? UploadPostViewController {
            destination.delegate = self
        } else if segue.identifier == "upcomingSegue",
                  let destination = segue.destination as? UpcomingEventsViewController {
            destination.delegate = self
            destination.feedList = feedList
        }
    }
    
    func didSelectMenuItem(name: String) {
        switch name {
            case "Location":
                break
            case "Friends list":
                break
            case "Upcoming Events":
                performSegue(withIdentifier: "upcomingSegue", sender: self)
                break
            case "Past Events":
                performSegue(withIdentifier: "pastSegue", sender: self)
                break
            case "Settings":
                break
            case "Logout":
            do {
                //if user is signed in it will sign them out then dismiss the current screen
                try Auth.auth().signOut()
                sideMenu?.dismiss(animated: true)
                self.dismiss(animated: true)
            } catch {
                print("Sign out error")
            }
                break
            default:
                break
        }
        sideMenu?.dismiss(animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("\(indexPath.row)")
            feedList.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()

            clearCoreData()

            coreData()

            
        } else if editingStyle == .insert {
        }
    }
    
    // function to clear core data
    func clearCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
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
    
    // basic function to store all of the current posts we have in our list
    func coreData() {
        
        for currPost in feedList {
            addPost(post: currPost)
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occurred while retrieving data")
            abort()
        }
        return (fetchedResults)!
    }
    
    func addPost(post: PostClass) {
        let postTemp = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context)
        postTemp.setValue(post.username, forKey: "username")
        postTemp.setValue(post.location, forKey: "location")
        postTemp.setValue(post.date, forKey: "date")
        postTemp.setValue(post.descript, forKey: "descript")
        postTemp.setValue(post.users, forKey: "users")
        saveContext()
    }
    
    func uploadPost(post: PostClass) {
        feedList.append(post)
        addPost(post: post)
    }
    
    func acceptAction(in cell: PostTableViewCell) {
        print("meow")
        if let indexPath = tableView.indexPath(for: cell){
            print("inside")
            feedList[indexPath.row].users.append((Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: ""))!)
            clearCoreData()
            coreData()
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(sideMenu!, animated: true)
    }

}

