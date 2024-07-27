//
//  UploadPostViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/22/24.
//

import UIKit
import FirebaseAuth

class UploadPostViewController: UIViewController {

    var delegate: UIViewController!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var decriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    
    @IBOutlet weak var joinMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationTextField.placeholder = "Location"
        decriptionTextField.placeholder = "Description"
        dateTextField.placeholder = "Date"
        eventTextField.placeholder = "Event Name"
        joinMeButton.layer.cornerRadius = 15
        locationTextField.borderStyle = UITextField.BorderStyle.roundedRect
        dateTextField.borderStyle = UITextField.BorderStyle.roundedRect
        eventTextField.borderStyle = UITextField.BorderStyle.roundedRect
        decriptionTextField.borderStyle = UITextField.BorderStyle.roundedRect
        decriptionTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        decriptionTextField.layer.borderWidth = 1
//        eventTextField.layer.borderWidth = 1
//        locationTextField.layer.borderWidth = 1
//        dateTextField.layer.borderWidth = 1
//        locationTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        dateTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        eventTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let usernameNoEmail = Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "")
        let newPost = PostClass(username: (Auth.auth().currentUser?.email)!, location: locationTextField.text!, descript: decriptionTextField.text!, date: dateTextField.text!, users: [usernameNoEmail!])
        let otherVC = delegate as! feed
        otherVC.uploadPost(post: newPost)
    }
    
}
