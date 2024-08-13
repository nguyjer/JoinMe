//
//  UINavViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 8/13/24.
//

import UIKit

class UINavViewController: UINavigationController {
    
    var locationDelegate: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let newDelegate = locationDelegate {
            newDelegate.dismiss(animated: false)
        }
    }

}
