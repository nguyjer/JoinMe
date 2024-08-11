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
    
    var events: [(id: String, title: String)] = []  // Array to keep track of event IDs and titles
    let eventStore = EKEventStore()
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        fetchEvents()
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
                events.append((id: eventIdentifier, title: title))
                saveToCoreData(eventIdentifier: eventIdentifier, title: title, startDate: startDatePicker.date, endDate: endDatePicker.date)
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
                DispatchQueue.main.async {
                    if granted {
                        self.createEvent()
                    } else {
                        self.postMessage(message: "No calendar access")
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
            self.postMessage(message: "Full access granted")
        case .writeOnly:
            self.postMessage(message: "Write-only access granted")
        @unknown default:
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
            deleteFromCoreData(eventIdentifier: eventIdentifier)
            if let index = events.firstIndex(where: { $0.id == eventIdentifier }) {
                events.remove(at: index)
            }
            postMessage(message: "Event removed from calendar and Core Data")
        } catch {
            postMessage(message: "Event not removed due to error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func removeEventSelected(_ sender: Any) {
        let alert = UIAlertController(title: "Select Event", message: "Choose the event you want to delete", preferredStyle: .alert)
        
        for event in events {
            let action = UIAlertAction(title: event.title, style: .destructive) { _ in
                self.deleteEvent(eventIdentifier: event.id)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveToCoreData(eventIdentifier: String, title: String, startDate: Date, endDate: Date) {
        let post = Post(context: context)
        post.savedEventId = eventIdentifier
        post.title = title
        post.startDate = startDate
        post.endDate = endDate
        
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
            if posts.isEmpty {
                print("No matching events found in Core Data")
            } else {
                for post in posts {
                    context.delete(post)
                }
                try context.save()
                print("Successfully deleted event from Core Data")
            }
        } catch {
            print("Failed to delete event from Core Data: \(error.localizedDescription)")
        }
    }
    
    func fetchEvents() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        do {
            let posts = try context.fetch(fetchRequest)
            events = posts.map { (id: $0.savedEventId ?? "", title: $0.title ?? "") }
        } catch {
            print("Failed to fetch events from Core Data: \(error.localizedDescription)")
        }
    }
    
    func postMessage(message: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
        }
    }
}
