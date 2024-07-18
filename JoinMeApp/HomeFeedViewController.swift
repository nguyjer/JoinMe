//
//  HomeFeedViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/18/24.
//

import UIKit
import FirebaseAuth

class HomeFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            //if user is signed in it will sign them out then dismiss the current screen
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }


}
