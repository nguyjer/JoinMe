//
//  ExpandedFriendsViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 8/15/24.
//

import UIKit
import CoreData

class ExpandedFriendsViewController: UIViewController {

    var currentFriend: NSManagedObject!
    
    @IBOutlet weak var profilePicture: UIImageView!

    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = currentFriend.value(forKey: "name") as? String
        usernameLabel.text = currentFriend.value(forKey: "username") as? String
        hometownLabel.text = currentFriend.value(forKey: "hometown") as? String
        bioLabel.text = currentFriend.value(forKey: "bio") as? String
        profilePicture.image = (currentFriend.value(forKey: "picture") as! PictureClass).picture
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    


}
