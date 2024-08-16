//
//  UploadPostViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/22/24.
//

import UIKit
import FirebaseAuth
import EventKit
import CoreData

protocol getInfo {
    func changeDate(eventID: String, start: Date, end: Date)
    func inviteFriend(friend: String)
    func addedLocation(selected:String)
}

class UploadPostViewController: UIViewController, getInfo, UITextFieldDelegate {
    
    let alert = UIAlertController(
                title: "One or more fields left blank",
                message: "Please fill them all out.",
                preferredStyle: .alert)
    let eventStore = EKEventStore()
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    
    var delegate: UIViewController!
    var currentUser: NSManagedObject?
    var eventIdentifier: String?
    var startDate: Date?
    var endDate: Date?
    var friendsInvited: [String] = []
    var eventLocation: String = ""
    
    @IBOutlet weak var joinMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsInvited.append(currentUser?.value(forKey: "username") as! String)
        eventTextField.delegate = self
        descriptionTextField.delegate = self
        // Do any additional setup after loading the view.
        joinMeButton.layer.cornerRadius = 15
        inviteButton.layer.cornerRadius = 15
        locationButton.layer.cornerRadius = 15
        eventTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authorizationStatus {
        case .notDetermined:
            if #available(iOS 17.0, *) {
                // Request full access to events
                eventStore.requestFullAccessToEvents { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                            
                        } else {
                            self.postMessage(message: "No calendar access")
                        }
                    }
                }
            } else {
                // Fallback for earlier iOS versions
                eventStore.requestAccess(to: .event) { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                        } else {
                            self.postMessage(message: "No calendar access")
                        }
                    }
                }
            }
        case .authorized:
            print("have access to calendar now")
        case .denied:
            self.postMessage(message: "Calendar access denied")
        case .restricted:
            self.postMessage(message: "Calendar access restricted")
        case .fullAccess:
            self.postMessage(message: "Calendar access has full access")
        case .writeOnly:
            self.postMessage(message: "Calendar access write only")
        default:
            self.postMessage(message: "Unknown authorization status")
        }
        
    }
    
    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        // If we have all the validated inputs, then do the rest
        
        if validateInputs() {
            let usernameNoEmail = Auth.auth().currentUser?.email?.replacingOccurrences(of: "@joinme.com", with: "")
            addEventCalendar()
            
            // Create new post
            let newPost = PostClass(
                username: usernameNoEmail!,
                location: eventLocation,
                descript: descriptionTextField.text!,
                users: friendsInvited,
                eventIdentifier: eventIdentifier!,
                startDate: startDate!,
                endDate: endDate!,
                eventTitle: eventTextField.text!
            )

            // Update user feeds
            let fetchedResults = retrieveUsers()
            for result in fetchedResults {
                if friendsInvited.contains(result.value(forKey: "username") as! String) {
                    var feedList = result.value(forKey: "feed") as! [PostClass]
                    feedList.append(newPost)
                    result.setValue(feedList, forKey: "feed")
                }
            }
            
            let otherVC = delegate as! feed
            otherVC.uploadPost(post: newPost)
            otherVC.reloadTable()

            dismiss(animated: true, completion: nil)
            
        } else {
            present(alert, animated: true)
        }
    }

    func validateInputs() -> Bool {
        guard let startDate = startDatePicker?.date, let endDate = endDatePicker?.date else {
            postMessage(message: "Date selection is incomplete.")
            return false
        }

        if eventLocation == "" || descriptionTextField.text == "" || eventTextField.text == "" /*|| friendsInvited.isEmpty */{
            postMessage(message: "All fields must be filled out.")
            return false
        }

        if startDate < Date() {
            postMessage(message: "Start date cannot be in the past.")
            return false
        }

        if endDate < startDate {
            postMessage(message: "End date cannot be before the start date.")
            return false
        }
        return true
    }
    
    func postMessage(message: String) {
        print(message)
    }
    
    func retrieveUsers() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            if let fetchedResults = try context.fetch(request) as? [NSManagedObject] {
                return fetchedResults
            }
        } catch {
            print("Error occurred while retrieving data: \(error)")
            abort()
        }
        return []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFriendSegue",
            let destination = segue.destination as? AddFriendViewController {
                destination.delegate = self
                destination.currentUser = currentUser
        }
        
        if segue.identifier == "addLocationSegue", 
            let destination = segue.destination as? AddLocationViewController {
                destination.delegate = self
        }
    }
    
    func createEvent() {
        guard let title = eventTextField.text, !title.isEmpty else {
            postMessage(message: "Title is missing")
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDatePicker.date
        event.endDate = endDatePicker.date
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            if let eventIdentifier = event.eventIdentifier {
                changeDate(eventID: eventIdentifier, start: event.startDate, end: event.endDate)
                postMessage(message: "Event added to calendar")
            } else {
                postMessage(message: "Failed to get event identifier")
            }
        } catch {
            postMessage(message: "Event not added due to error: \(error.localizedDescription)")
        }
    }

    func addEventCalendar() {
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authorizationStatus {
        case .notDetermined:
            if #available(iOS 17.0, *) {
                // Request full access to events
                eventStore.requestFullAccessToEvents { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                            self.createEvent()
                        } else {
                            self.postMessage(message: "No calendar access")
                        }
                    }
                }
            } else {
                // Fallback for earlier iOS versions
                eventStore.requestAccess(to: .event) { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                            self.createEvent()
                        } else {
                            self.postMessage(message: "No calendar access")
                        }
                    }
                }
            }
        case .authorized:
            createEvent()
        case .denied:
            self.postMessage(message: "Calendar access denied")
        case .restricted:
            self.postMessage(message: "Calendar access restricted")
        case .fullAccess:
            self.postMessage(message: "Calendar access has full access")
        case .writeOnly:
            self.postMessage(message: "Calendar access write only")
        default:
            self.postMessage(message: "Unknown authorization status")
        }
    }
    
    func deleteEvent(eventIdentifier: String) {
        guard let eventToRemove = eventStore.event(withIdentifier: eventIdentifier) else {
            self.postMessage(message: "Event not found in calendar")
            return
        }
        
        do {
            try eventStore.remove(eventToRemove, span: .thisEvent)
            postMessage(message: "Event removed from calendar")
        } catch {
            postMessage(message: "Event not removed due to error: \(error.localizedDescription)")
        }
    }
    
    
    func changeDate(eventID: String, start: Date, end: Date) {
        eventIdentifier = eventID
        startDate = start
        endDate = end
    }
    
    func inviteFriend(friend: String) {
        if friendsInvited.contains(friend) {
            return
        }
        friendsInvited.append(friend)
    }
    
    func addedLocation(selected: String) {
        eventLocation = selected
    }
}
 
