//
//  CalendarViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/1/24.
//

// CalendarViewController.swift
// JoinMeApp
//
// Created by Katherine Liang on 8/1/24.
//

//import UIKit
//import EventKit
//
//class CalendarViewController: UIViewController {
//
//    @IBOutlet weak var eventTitle: UITextField!
//    @IBOutlet weak var startDatePicker: UIDatePicker!
//    @IBOutlet weak var endDatePicker: UIDatePicker!
//    @IBOutlet weak var statusLabel: UILabel!
//    
//    var events: [PostClass] = []
//    let eventStore = EKEventStore()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Additional setup
//        fetchEvents()
//    }
//    
//    func createEvent() {
//        guard let title = eventTitle.text, !title.isEmpty else {
//            postMessage(message: "Title is missing")
//            return
//        }
//        
//        let event = EKEvent(eventStore: eventStore)
//        event.title = title
//        event.startDate = startDatePicker.date
//        event.endDate = endDatePicker.date
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        
//        do {
//            try eventStore.save(event, span: .thisEvent)
//            if let eventIdentifier = event.eventIdentifier {
//                let newEvent = PostClass(
//                    username: title,
//                    location: "",
//                    descript: "",
//                    date: DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .short, timeStyle: .short),
//                    users: [],
//                    eventIdentifier: eventIdentifier,
//                    title: title,
//                    startDate: startDatePicker.date,
//                    endDate: endDatePicker.date
//                )
//                events.append(newEvent)
//                postMessage(message: "Event added to calendar")
//            } else {
//                postMessage(message: "Failed to get event identifier")
//            }
//        } catch {
//            postMessage(message: "Event not added due to error: \(error.localizedDescription)")
//        }
//    }
//
//    @IBAction func addEventSelected(_ sender: Any) {
//        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
//        
//        switch authorizationStatus {
//        case .notDetermined:
//            eventStore.requestAccess(to: .event) { (granted, error) in
//                DispatchQueue.main.async {
//                    if granted {
//                        self.createEvent()
//                    } else {
//                        self.postMessage(message: "No calendar access")
//                    }
//                }
//            }
//        case .authorized:
//            createEvent()
//        case .denied:
//            self.postMessage(message: "Calendar access denied")
//        case .restricted:
//            self.postMessage(message: "Calendar access restricted")
//        case .fullAccess:
//            self.postMessage(message: "Full access granted")
//        case .writeOnly:
//            self.postMessage(message: "Write-only access granted")
//        @unknown default:
//            self.postMessage(message: "Unknown authorization status")
//        }
//    }
//    
//    func deleteEvent(eventIdentifier: String) {
//        guard let eventToRemove = eventStore.event(withIdentifier: eventIdentifier) else {
//            self.postMessage(message: "Event not found in calendar")
//            return
//        }
//        
//        do {
//            try eventStore.remove(eventToRemove, span: .thisEvent)
//            if let index = events.firstIndex(where: { $0.eventIdentifier == eventIdentifier }) {
//                events.remove(at: index)
//            }
//            postMessage(message: "Event removed from calendar")
//        } catch {
//            postMessage(message: "Event not removed due to error: \(error.localizedDescription)")
//        }
//    }
//    
//    @IBAction func removeEventSelected(_ sender: Any) {
//        let alert = UIAlertController(title: "Select Event", message: "Choose the event you want to delete", preferredStyle: .alert)
//        
//        for event in events {
//            let action = UIAlertAction(title: event.title, style: .destructive) { _ in
//                self.deleteEvent(eventIdentifier: event.eventIdentifier)
//            }
//            alert.addAction(action)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    func fetchEvents() {
//        // Load events from saved data or a file, if needed.
//        // This is where you would load your events into the `events` array.
//    }
//    
//    func postMessage(message: String) {
//        DispatchQueue.main.async {
//            self.statusLabel.text = message
//        }
//    }
//}

// CalendarViewController.swift
// JoinMeApp
//
// Created by Katherine Liang on 8/1/24.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var statusLabel: UILabel!

    var eventTitle: String?
    
    //store eventstore in user entity
    let eventStore = EKEventStore()
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        fetchEvents()
    }
    
    func createEvent() {
        guard let title = eventTitle, !title.isEmpty else {
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
                let otherVC = delegate as! datePicker
                otherVC.changeDate(eventID: eventIdentifier, start: event.startDate, end: event.endDate)
                postMessage(message: "Event added to calendar")
            } else {
                postMessage(message: "Failed to get event identifier")
            }
        } catch {
            postMessage(message: "Event not added due to error: \(error.localizedDescription)")
        }
    }

    @IBAction func addEventSelected(_ sender: Any) {
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
    

    
    func fetchEvents() {
        // Load events from saved data or a file, if needed.
        // This is where you would load your events into the `events` array.
    }
    
    func postMessage(message: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
        }
    }
}
