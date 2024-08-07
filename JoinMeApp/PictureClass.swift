//
//  PictureClass.swift
//  JoinMeApp
//
//  Created by Tommy Ly on 8/7/24.
//

import Foundation
import UIKit

public class PictureClass: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    var picture:UIImage
    
    init(picture:UIImage) {
        self.picture = picture
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(picture, forKey: "picture")
    }
    
    public required init?(coder: NSCoder) {
        picture = coder.decodeObject(forKey: "picture") as! UIImage
    }
}
