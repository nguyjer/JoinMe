//
//  CalendarViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/1/24.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var events: [PostClass] = []
        var currentMonthIndex: Int = 0
        var currentYear: Int = 0

        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCalendar()
            fetchEvents()
            setupMonthLabel()
        }

        func fetchEvents() {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            var fetchedResults: [NSManagedObject]? = nil

            do {
                fetchedResults = try context.fetch(request) as? [NSManagedObject]
                for result in fetchedResults ?? [] {
                    if let username = result.value(forKey: "username") as? String,
                       let location = result.value(forKey: "location") as? String,
                       let descript = result.value(forKey: "descript") as? String,
                       let date = result.value(forKey: "date") as? String,
                       let users = result.value(forKey: "users") as? [String] {
                        let post = PostClass(username: username, location: location, descript: descript, date: date, users: users)
                        events.append(post)
                    }
                }
            } catch {
                print("Error occurred while retrieving data")
            }
        }

        func setupCalendar() {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            let date = Date()
            let calendar = Calendar.current
            currentMonthIndex = calendar.component(.month, from: date) - 1
            currentYear = calendar.component(.year, from: date)
        }

        func setupMonthLabel() {
            monthYearLabel.text = "\(months[currentMonthIndex]) \(currentYear)"
        }

        @IBAction func nextMonthPressed(_ sender: Any) {
            if currentMonthIndex == 11 {
                currentMonthIndex = 0
                currentYear += 1
            } else {
                currentMonthIndex += 1
            }
            setupMonthLabel()
            collectionView.reloadData()
        }

        @IBAction func previousMonthButtonPressed(_ sender: Any) {
            if currentMonthIndex == 0 {
                currentMonthIndex = 11
                currentYear -= 1
            } else {
                currentMonthIndex -= 1
            }
            setupMonthLabel()
            collectionView.reloadData()
        }

        // UICollectionViewDataSource Methods
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // Number of days in the current month
            let dateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            let range = calendar.range(of: .day, in: .month, for: date)!
            return range.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.dayLabel.text = "\(indexPath.row + 1)"
            return cell
        }

        // UICollectionViewDelegate Methods
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Handle day selection and show events
            let selectedDay = indexPath.row + 1
            let selectedDateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1, day: selectedDay)
            let calendar = Calendar.current
            if let selectedDate = calendar.date(from: selectedDateComponents) {
                // Filter and show events for the selected date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd"
                let selectedDateString = dateFormatter.string(from: selectedDate)

                let eventsForSelectedDate = events.filter { $0.date == selectedDateString }
                // Show events for the selected date (e.g., in a new view controller or an alert)
                // Example: print events
                print(eventsForSelectedDate)
            }
        }
    }
