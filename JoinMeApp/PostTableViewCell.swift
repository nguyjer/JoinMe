//
//  PostTableViewCell.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 7/25/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    var delegate: UIViewController!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameInvite: UILabel!
    
    
    @IBOutlet weak var dateScheduled: UILabel!
    
    

    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func acceptButton(_ sender: Any) {
        let otherVC = delegate as! feed
        otherVC.acceptAction(in: self)
        acceptButton.isHidden = true
        statusLabel.text = "accepted"
    }
    
    
    @IBAction func declineButton(_ sender: Any) {
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
