//
//  SettingsTableViewCell.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/2/24.
//

import UIKit
import UserNotifications

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var labelSettings: UILabel!
    @IBOutlet weak var iconSettings: UIImageView!
    @IBOutlet weak var pushIcon: UILabel!
    var delegate: UIViewController!

    @IBAction func notificationToggle(_ sender: Any) {
        if notificationsSwitch.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) {
                (granted,error) in
                if granted {
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        } else {
            let controller = UIAlertController(
                title: "Turn Off Notifications",
                message: "To turn off notications, please go to your Settings application -> JoinMe -> Notification Settings -> Toggle Off",
                preferredStyle: .actionSheet)
            
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            delegate.present(controller, animated: true)
        }
    }
    
}
