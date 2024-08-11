//import Foundation
//
//public class PostClass: NSObject, NSSecureCoding {
//    let username: String
//    let location: String
//    let descript: String
//    let date: String
//    var users: [String]
//    
//    init(username: String, location: String, descript: String, date: String, users: [String]) {
//        self.username = username
//        self.location = location
//        self.descript = descript
//        self.date = date
//        self.users = users
//    }
//    
//    public static var supportsSecureCoding: Bool {
//        return true
//    }
//    
//    public func encode(with coder: NSCoder) {
//        coder.encode(username, forKey: "username")
//        coder.encode(location, forKey: "location")
//        coder.encode(descript, forKey: "descript")
//        coder.encode(date, forKey: "date")
//        coder.encode(users, forKey: "users")
//    }
//    
//    public required init?(coder: NSCoder) {
//        username = coder.decodeObject(forKey: "username") as! String
//        location = coder.decodeObject(forKey: "location") as! String
//        descript = coder.decodeObject(forKey: "descript") as! String
//        date = coder.decodeObject(forKey: "date") as! String
//        users = coder.decodeObject(forKey: "users") as! [String]
//    }
//}
import Foundation

public class PostClass: NSObject, NSSecureCoding {
    let username: String
    let location: String
    let descript: String
    let date: String
    var users: [String]
    let eventIdentifier: String
    let title: String
    let startDate: Date
    let endDate: Date

    init(username: String, location: String, descript: String, date: String, users: [String], eventIdentifier: String, title: String, startDate: Date, endDate: Date) {
        self.username = username
        self.location = location
        self.descript = descript
        self.date = date
        self.users = users
        self.eventIdentifier = eventIdentifier
        self.title = title
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
        coder.encode(date, forKey: "date")
        coder.encode(users, forKey: "users")
        coder.encode(eventIdentifier, forKey: "eventIdentifier")
        coder.encode(title, forKey: "title")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(endDate, forKey: "endDate")
    }

    public required init?(coder: NSCoder) {
        username = coder.decodeObject(forKey: "username") as! String
        location = coder.decodeObject(forKey: "location") as! String
        descript = coder.decodeObject(forKey: "descript") as! String
        date = coder.decodeObject(forKey: "date") as! String
        users = coder.decodeObject(forKey: "users") as! [String]
        eventIdentifier = coder.decodeObject(forKey: "eventIdentifier") as! String
        title = coder.decodeObject(forKey: "title") as! String
        startDate = coder.decodeObject(forKey: "startDate") as! Date
        endDate = coder.decodeObject(forKey: "endDate") as! Date
    }
}
