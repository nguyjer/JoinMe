//
//  MenuViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 7/29/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 1. Add a Bar Button to FriendFeedVC
    
    // 2. Connect the bridge once FriendsFeedVC is made
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            performSegue(withIdentifier: "showProfile", sender: self)
        case 1:
            performSegue(withIdentifier: "showFriendsList", sender: self)
        case 2:
            performSegue(withIdentifier: "showUpcomingEvents", sender: self)
        case 3:
            performSegue(withIdentifier: "showPastEvents", sender: self)
        case 4:
            performSegue(withIdentifier: "showSettings", sender: self)
        case 5:
            performSegue(withIdentifier: "logout", sender: self)
        default:
            break
        }
    }
    
    // 3. Cancel button pressed
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
