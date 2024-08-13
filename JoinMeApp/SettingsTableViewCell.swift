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
//        pushIcon.isHidden = true
//        notificationsSwitch.isHidden = false
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) {
                    (granted,error) in
                    if granted {
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                break
            case .denied:
                DispatchQueue.main.sync {
                    self.notificationsSwitch.setOn(false, animated: true)
                    let controller = UIAlertController(
                        title: "Turn On Notifications",
                        message: "To turn on notications, please go to your Settings application -> JoinMe -> Notification Settings -> Toggle On",
                        preferredStyle: .actionSheet)
                    
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.delegate.present(controller, animated: true)
                }
                break
            case .authorized:
                DispatchQueue.main.sync {
                    self.notificationsSwitch.setOn(true, animated: true)
                    let controller = UIAlertController(
                        title: "Turn Off Notifications",
                        message: "To turn off notications, please go to your Settings application -> JoinMe -> Notification Settings -> Toggle Off",
                        preferredStyle: .actionSheet)
                    
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.delegate.present(controller, animated: true)
                }
                break
            case .provisional:
                break
            case .ephemeral:
                break
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                break
            case .denied:
                DispatchQueue.main.sync {
                    self.notificationsSwitch.setOn(false, animated: true)
                }
                
                break
            case .authorized:
                DispatchQueue.main.sync {
                    self.notificationsSwitch.setOn(true, animated: true)
                }
                break
            case .provisional:
                break
            case .ephemeral:
                break
            default:
                break
            }
        }

    }
}
