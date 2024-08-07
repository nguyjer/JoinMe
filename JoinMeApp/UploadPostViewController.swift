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
    let alert = UIAlertController(
                title: "One or more fields left blank",
                message: "Please fill them all out.",
                preferredStyle: .alert)
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    
    @IBOutlet weak var joinMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        joinMeButton.layer.cornerRadius = 15
        locationTextField.borderStyle = UITextField.BorderStyle.roundedRect
        dateTextField.borderStyle = UITextField.BorderStyle.roundedRect
        eventTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if locationTextField.text != "", descriptionTextField.text != "", dateTextField.text != "", eventTextField.text != "" {
            let usernameNoEmail = Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "")
            let newPost = PostClass(username: (Auth.auth().currentUser?.email)!, location: locationTextField.text!, descript: descriptionTextField.text!, date: dateTextField.text!, users: [usernameNoEmail!])
            let otherVC = delegate as! feed
            otherVC.uploadPost(post: newPost)
            self.navigationController?.popViewController(animated: true)
        } else {
            present(alert, animated: true)
        }
    }
    
}
