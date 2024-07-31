//
//  SideMenuTableViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/26/24.
//

//import UIKit
//import Foundation
//
//protocol MenuControllerDelegate {
//    func didSelectMenuItem(name: String)
//}
//
//class SideMenuTableViewController: UITableViewController {
//    
//    private let menuItems: [String]
//    var delegate: MenuControllerDelegate! 
//
//    init(with menuItems: [String]) {
//        self.menuItems = menuItems
//        super.init(nibName: nil, bundle: nil)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) had not been implemented")
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return menuItems.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = menuItems[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate.didSelectMenuItem(name: menuItems[indexPath.row])
//    }
//}

import UIKit
import Foundation

protocol MenuControllerDelegate {
    func didSelectMenuItem(name: String)
}

class SideMenuTableViewController: UITableViewController {
    
    private let menuItems: [(text: String, symbol: String)]
    var delegate: MenuControllerDelegate!
    
    init(with menuItems: [(text: String, symbol: String)]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) had not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.text
        cell.imageView?.image = UIImage(systemName: menuItem.symbol)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectMenuItem(name: menuItems[indexPath.row].text)
    }
}
