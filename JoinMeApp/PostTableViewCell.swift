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
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var dateScheduled: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    var hid: Bool = false

    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func acceptButton(_ sender: Any) {
        acceptButton.isHidden = true
        declineButton.isHidden = true
        statusLabel.text = "Accepted"
        let otherVC = delegate as! feed
        otherVC.acceptAction(in: self)
    }
    
    
    @IBAction func declineButton(_ sender: Any) {
        let otherVC = delegate as! feed
        otherVC.declineAction(in: self)
    }
    
    func hideButtons() {
        acceptButton.isHidden = true
        declineButton.isHidden = true
        hid = true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        usernameInvite.numberOfLines = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
