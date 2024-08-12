//
//  UploadPostViewController.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/22/24.
//

import UIKit
import FirebaseAuth
import EventKit

protocol datePicker {
    func changeDate(eventID: String, start: Date, end: Date)
}

class UploadPostViewController: UIViewController, datePicker {

    var delegate: UIViewController!
    let alert = UIAlertController(
                title: "One or more fields left blank",
                message: "Please fill them all out.",
                preferredStyle: .alert)
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    
    var eventIdentifier: String?
    var startDate: Date?
    var endDate: Date?
    
    @IBOutlet weak var joinMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        joinMeButton.layer.cornerRadius = 15
        locationTextField.borderStyle = UITextField.BorderStyle.roundedRect
        eventTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.borderStyle = UITextField.BorderStyle.roundedRect
        descriptionTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if locationTextField.text != "", descriptionTextField.text != "", eventTextField.text != "" {
            let usernameNoEmail = Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "")
            addEventCalendar()
            let newPost = PostClass(
                username: (Auth.auth().currentUser?.email)!,
                location: locationTextField.text!,
                descript: descriptionTextField.text!,
                users: [usernameNoEmail!],
                eventIdentifier: eventIdentifier!,
                startDate: startDate!,
                endDate: endDate!
            )
            let otherVC = delegate as! feed
            otherVC.uploadPost(post: newPost)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datePickerSegue",
            let destination = segue.destination as? CalendarViewController {
                destination.delegate = self
            destination.eventTitle = eventTextField.text
        }
    }
    
    //store eventstore in user entity
    let eventStore = EKEventStore()
    
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
    
    
    func postMessage(message: String) {
        
//        present(alert, animated: true)
    }
    
    func changeDate(eventID: String, start: Date, end: Date) {
        eventIdentifier = eventID
        startDate = start
        endDate = end
    }
}
