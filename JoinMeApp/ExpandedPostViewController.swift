//
//  ExpandedPostViewController.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/12/24.
//

import UIKit

class ExpandedPostViewController: UIViewController {

    var post: PostClass!
    var profilePicture1: UIImage?
    var realName: String?
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usersJoiningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var usersString = "Users Joining: \(post.users)"
        // Do any additional setup after loading the view.
        profilePicture.image = profilePicture1
        nameLabel.text = realName
        usernameLabel.text = post.username
        eventNameLabel.text = "\(post.eventTitle)"
        locationLabel.text = "Location: \(post.location)"
        dateStartLabel.text = "Start Date: \(post.startDate)"
        dateEndLabel.text = "End Date: \(post.endDate)"
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        usersString = usersString.replacingOccurrences(of: "[", with: "")
        usersString = usersString.replacingOccurrences(of: "]", with: "")
        usersJoiningLabel.text = usersString.replacingOccurrences(of: "\"", with: "")
    }
}
