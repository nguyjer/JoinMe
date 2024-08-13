//
//  FriendsListTableViewCell.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/12/24.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {

    
    var delegate: UIViewController!
    
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var userPersonalName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var sendRequestButton: UIButton!
    // Add this button for sending friend requests
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
