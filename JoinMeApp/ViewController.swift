//
//  ViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/9/24.
//

import UIKit
import FirebaseAuth
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol feed {
    func uploadPost(post: PostClass)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, feed {
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "postCell"
    
    var feedList:[PostClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadSegue",
           let destination = segue.destination as? UploadPostViewController {
            destination.delegate = self
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
    
    func uploadPost(post: PostClass) {
        feedList.append(post)
        let postTemp = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context)
        postTemp.setValue(post.username, forKey: "username")
        postTemp.setValue(post.location, forKey: "location")
        postTemp.setValue(post.date, forKey: "date")
        postTemp.setValue(post.descript, forKey: "descript")
        saveContext()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //allows scrollable table cells
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        
        return cell
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//    }
    
    
    
    //temporary sign out
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            //if user is signed in it will sign them out then dismiss the current screen
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }
}

