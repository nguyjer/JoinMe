//
//  CalendarViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/1/24.
//

import UIKit
import EventKit
import CoreData

class CalendarViewController: UIViewController {

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var statusLabel: UILabel!
    
    var savedEventId: String?
    let eventStore = EKEventStore()
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
    }
    
    func createEvent() {
        guard let title = eventTitle.text, !title.isEmpty else {
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
                savedEventId = eventIdentifier
                saveToCoreData(eventIdentifier: eventIdentifier)
                postMessage(message: "Event added to calendar and Core Data")
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
            eventStore.requestFullAccessToEvents { (granted, error) in
                if granted {
                    self.createEvent()
                } else {
                    self.postMessage(message: "No calendar access")
                }
            }
        case .authorized, .fullAccess, .writeOnly:
            createEvent()
        case .denied:
            self.postMessage(message: "Calendar access denied")
        case .restricted:
            self.postMessage(message: "Calendar access restricted")
        @unknown default:
            self.postMessage(message: "Unknown authorization status")
        }
    }
    
    func deleteEvent(eventIdentifier: String) {
        if let eventToRemove = eventStore.event(withIdentifier: eventIdentifier) {
            do {
                try eventStore.remove(eventToRemove, span: .thisEvent)
                deleteFromCoreData(eventIdentifier: eventIdentifier)
                postMessage(message: "Event removed from calendar and Core Data")
            } catch {
                postMessage(message: "Event not removed due to error: \(error.localizedDescription)")
            }
        } else {
            self.postMessage(message: "Event not found")
        }
    }
    
    @IBAction func removeEventSelected(_ sender: Any) {
        guard let savedEventId = savedEventId else {
            postMessage(message: "No event selected to remove")
            return
        }

        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authorizationStatus {
        case .notDetermined:
            eventStore.requestFullAccessToEvents { (granted, error) in
                if granted {
                    self.deleteEvent(eventIdentifier: savedEventId)
                } else {
                    self.postMessage(message: "No calendar access")
                }
            }
        case .authorized, .fullAccess, .writeOnly:
            deleteEvent(eventIdentifier: savedEventId)
        case .denied:
            self.postMessage(message: "Calendar access denied")
        case .restricted:
            self.postMessage(message: "Calendar access restricted")
        @unknown default:
            self.postMessage(message: "Unknown authorization status")
        }
    }
    
    func saveToCoreData(eventIdentifier: String) {
        let post = Post(context: context)
        post.date = "\(startDatePicker.date)"
        post.descript = eventTitle.text
        post.savedEventId = eventIdentifier
        
        do {
            try context.save()
        } catch {
            print("Failed to save event to Core Data: \(error.localizedDescription)")
        }
    }
    
    func deleteFromCoreData(eventIdentifier: String) {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "savedEventId == %@", eventIdentifier)
        
        do {
            let posts = try context.fetch(fetchRequest)
            for post in posts {
                context.delete(post)
            }
            try context.save()
        } catch {
            print("Failed to delete event from Core Data: \(error.localizedDescription)")
        }
    }
    
    func postMessage(message: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
        }
    }
}
