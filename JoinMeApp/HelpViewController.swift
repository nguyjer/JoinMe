//
//  HelpViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/7/24.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openMailApp()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func presentMailComposeViewController() {
        guard MFMailComposeViewController.canSendMail() else {
            // Show an alert if mail cannot be sent
            let alert = UIAlertController(title: "Error", message: "Mail services are not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["joinmeapphelp@joinme.com"])
        mailComposeVC.setSubject("Subject Here")
        mailComposeVC.setMessageBody("Body of the email.", isHTML: false)
        
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    // Implement the delegate method to handle the result
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func openMailApp() {
        let email = "joinmeapphelp@joinme.com"
        let subject = "Subject Here"
        let body = "Body of the email."
        
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Show an alert if Mail cannot be opened
                let alert = UIAlertController(title: "Error", message: "Mail services are not available.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
