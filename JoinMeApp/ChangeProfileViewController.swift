//
//  ChangeProfileViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/5/24.
//

import UIKit

class ChangeProfileViewController: UIViewController {
    
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var delegate: UIViewController!
    var titleField: String!
    
    override func viewWillAppear(_ animated: Bool) {
        changeLabel.text = titleField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = nil
    }
    
    @IBAction func changePressed(_ sender: Any) {
        if textField.text == "" {
            let minicontroller = UIAlertController(title: "No Entry Detected", message: "Please enter your new \(String(describing: titleField))", preferredStyle: .alert)
            minicontroller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(minicontroller, animated: true)
            return
        } else {
            //also update the respective core data field
            let controller = delegate as! AccountViewController
            controller.userUpdated()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
