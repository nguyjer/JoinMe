//
//  SettingsViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/2/24.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let settingsOptions:[String] = ["Your Account", "Notifications", "Privacy", "Help"]
    var currentUser: NSObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        logOut.setTitleColor(.red, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! SettingsTableViewCell
        let row = indexPath.row
        cell.iconSettings.image = UIImage(named: "settings\(row)")
        cell.labelSettings.text = settingsOptions[row]
        cell.delegate = self
        if row == 1 {
            cell.pushIcon.isHidden = true
            cell.notificationsSwitch.isHidden = false
        } else {
            cell.pushIcon.textColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "accountSegue", sender: self)
        case 1:
            //empty for now but enable and disable notfications

            break
        case 2:
            // privacy segue
            performSegue(withIdentifier: "privacySegue", sender: self)
        case 3:
            // help segue
            performSegue(withIdentifier: "helpSegue", sender: self)
            break
        default:
            print("Not supposed to happen")
            abort()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountSegue",
                  let destination = segue.destination as?
                    AccountViewController {
            destination.currentUser = currentUser
        }
    }
}
