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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let newPost = PostClass(username: (Auth.auth().currentUser?.email)!, location: locationTextField.text!, descript: decriptionTextField.text!, date: dateTextField.text!)
        let otherVC = delegate as! feed
        otherVC.uploadPost(post: newPost)
    }
    
}
