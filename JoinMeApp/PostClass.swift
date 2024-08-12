import Foundation

public class PostClass: NSObject, NSSecureCoding {
    let username: String
    let location: String
    let descript: String
    var users: [String]
    let eventIdentifier: String
    let startDate: Date
    let endDate: Date
    
    init(username: String, location: String, descript: String, users: [String], eventIdentifier: String, startDate: Date, endDate: Date) {
        self.username = username
        self.location = location
        self.descript = descript
        self.users = users
        self.eventIdentifier = eventIdentifier
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(location, forKey: "location")
        coder.encode(descript, forKey: "descript")
        coder.encode(users, forKey: "users")
        coder.encode(eventIdentifier, forKey: "eventIdentifier")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(endDate, forKey: "endDate")
    }
    
    public required init?(coder: NSCoder) {
        username = coder.decodeObject(forKey: "username") as! String
        location = coder.decodeObject(forKey: "location") as! String
        descript = coder.decodeObject(forKey: "descript") as! String
        users = coder.decodeObject(forKey: "users") as! [String]
        eventIdentifier = coder.decodeObject(forKey: "eventIdentifier") as! String
        startDate = coder.decodeObject(forKey: "startDate") as! Date
        endDate = coder.decodeObject(forKey: "endDate") as! Date
    }
}
