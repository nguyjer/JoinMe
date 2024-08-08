//
//  CalendarCell.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/1/24.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dayOfMonth: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            contentView.backgroundColor = UIColor.white // or any color that contrasts with the text
            dayOfMonth.textColor = UIColor.black // or any color that contrasts with the background
        }
}

