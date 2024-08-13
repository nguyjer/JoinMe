//
//  FriendsListTableViewCell.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/12/24.
//

import UIKit

protocol FriendsListTableViewCellDelegate: AnyObject {
    func addFriendButtonTapped(_ cell: FriendsListTableViewCell)
}

class FriendsListTableViewCell: UITableViewCell {

    
    var delegate: UIViewController!
    
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var userPersonalName: UILabel!
    @IBOutlet weak var username: UILabel!
    

    
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
