import Foundation

public class PostClass: NSObject, NSSecureCoding {
    let username: String
    let location: String
    let descript: String
    let date: String
    var users: [String]
    
    init(username: String, location: String, descript: String, date: String, users: [String]) {
        self.username = username
        self.location = location
        self.descript = descript
        self.date = date
        self.users = users
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(location, forKey: "location")
        coder.encode(descript, forKey: "descript")
        coder.encode(date, forKey: "date")
        coder.encode(users, forKey: "users")
    }
    
    public required init?(coder: NSCoder) {
        username = coder.decodeObject(forKey: "username") as! String
        location = coder.decodeObject(forKey: "location") as! String
        descript = coder.decodeObject(forKey: "descript") as! String
        date = coder.decodeObject(forKey: "date") as! String
        users = coder.decodeObject(forKey: "users") as! [String]
    }
}
