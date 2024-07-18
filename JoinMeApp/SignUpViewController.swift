//
//  SignUpViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/18/24.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "signUpSegue", sender: self)
                self.userTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        confirmTextField.placeholder = "Confirm Password"
        emailTextField.placeholder = "Email"
        numberTextField.placeholder = "Number"
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                    title: "Sign Up Error",
                    message: "",
                    preferredStyle: .alert)
        
        if passwordTextField.text != confirmTextField.text {
            alert.message = "Unsuccesful Sign Up: Password's do not match"
            present(alert, animated: true)
            return
        }
        //appends an @ domain to comply with firebase template
        let username = userTextField.text! + ("@JoinMe.com")
        Auth.auth().createUser(withEmail: username, password: passwordTextField.text!) {
            authResult, error in
            if let error = error as NSError? {
                alert.message = "\(error.localizedDescription)"
                self.present(alert, animated: true)
            }
        }
    }
    

    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
