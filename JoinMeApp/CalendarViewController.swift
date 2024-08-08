//
//  CalendarViewController.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/1/24.
//

import UIKit
import CoreData

//class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    @IBOutlet weak var monthYearLabel: UILabel!
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    var events: [PostClass] = []
//        var currentMonthIndex: Int = 0
//        var currentYear: Int = 0
//
//        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            setupCalendar()
//            fetchEvents()
//            setupMonthLabel()
//        }
//
//        func fetchEvents() {
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
//            var fetchedResults: [NSManagedObject]? = nil
//
//            do {
//                fetchedResults = try context.fetch(request) as? [NSManagedObject]
//                for result in fetchedResults ?? [] {
//                    if let username = result.value(forKey: "username") as? String,
//                       let location = result.value(forKey: "location") as? String,
//                       let descript = result.value(forKey: "descript") as? String,
//                       let date = result.value(forKey: "date") as? String,
//                       let users = result.value(forKey: "users") as? [String] {
//                        let post = PostClass(username: username, location: location, descript: descript, date: date, users: users)
//                        events.append(post)
//                    }
//                }
//            } catch {
//                print("Error occurred while retrieving data")
//            }
//        }
//
//        func setupCalendar() {
//            collectionView.dataSource = self
//            collectionView.delegate = self
//            
//            let date = Date()
//            let calendar = Calendar.current
//            currentMonthIndex = calendar.component(.month, from: date) - 1
//            currentYear = calendar.component(.year, from: date)
//        }
//
//        func setupMonthLabel() {
//            monthYearLabel.text = "\(months[currentMonthIndex]) \(currentYear)"
//        }
//
//        @IBAction func nextMonthPressed(_ sender: Any) {
//            if currentMonthIndex == 11 {
//                currentMonthIndex = 0
//                currentYear += 1
//            } else {
//                currentMonthIndex += 1
//            }
//            setupMonthLabel()
//            collectionView.reloadData()
//        }
//
//        @IBAction func previousMonthButtonPressed(_ sender: Any) {
//            if currentMonthIndex == 0 {
//                currentMonthIndex = 11
//                currentYear -= 1
//            } else {
//                currentMonthIndex -= 1
//            }
//            setupMonthLabel()
//            collectionView.reloadData()
//        }
//
//        // UICollectionViewDataSource Methods
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            // Number of days in the current month
//            let dateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1)
//            let calendar = Calendar.current
//            let date = calendar.date(from: dateComponents)!
//            let range = calendar.range(of: .day, in: .month, for: date)!
//            return range.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
//            cell.dayLabel.text = "\(indexPath.row + 1)"
//            return cell
//        }
//
//        // UICollectionViewDelegate Methods
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            // Handle day selection and show events
//            let selectedDay = indexPath.row + 1
//            let selectedDateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1, day: selectedDay)
//            let calendar = Calendar.current
//            if let selectedDate = calendar.date(from: selectedDateComponents) {
//                // Filter and show events for the selected date
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-mm-dd"
//                let selectedDateString = dateFormatter.string(from: selectedDate)
//
//                let eventsForSelectedDate = events.filter { $0.date == selectedDateString }
//                // Show events for the selected date (e.g., in a new view controller or an alert)
//                // Example: print events
//                print(eventsForSelectedDate)
//            }
//        }
//    }

//class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    @IBOutlet weak var monthLabel: UILabel!
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    var selectedDate = Date()
//    var totalSquares = [String]()
//
//    override func viewDidLoad() {
//            super.viewDidLoad()
//            setCellsView()
//            setMonthView()
//
//    }
//    
//    func setCellsView() {
//        // 2 is an arbitrary number for padding and 8 = days + 1
//        let width = (collectionView.frame.size.width - 2) / 8
//        let height = (collectionView.frame.size.height - 2) / 8
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.itemSize = CGSize(width: width, height: height)
//    }
//    
//    func setMonthView() {
//        totalSquares.removeAll()
//        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
//        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
//        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
//        
//        var count: Int = 1
//        
//        while (count <= 42) {
//            if (count <= startingSpaces || count - startingSpaces > daysInMonth){
//                totalSquares.append("")
//            } else {
//                totalSquares.append(String(count - startingSpaces))
//            }
//            count += 1
//        }
//        
//        monthLabel.text = CalendarHelper().monthString(date: selectedDate) +
//        " " + CalendarHelper().yearString(date: selectedDate)
//        collectionView.reloadData()
//        
//    }
//    
//    
//        @IBAction func nextMonthPressed(_ sender: Any) {
//            selectedDate = CalendarHelper().plusMonth(date: selectedDate)
//            setMonthView()
//        }
//
//        @IBAction func previousMonthButtonPressed(_ sender: Any) {
//            selectedDate = CalendarHelper().minusMonth(date: selectedDate)
//            setMonthView()
//        }
//
//        // UICollectionViewDataSource Methods
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            totalSquares.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
//            cell.dayOfMonth.text = totalSquares[indexPath.item]
//            return cell
//        }
//
//    
//    // Screen shouldn't rotate
//    override open var shouldAutorotate: Bool {
//        return false
//    }
//    
//    }

//class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    @IBOutlet weak var monthLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    private let calendarHelper = CalendarHelper()
//    var selectedDate = Date()
//    var totalSquares = [String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        setCellsView()
//        setMonthView()
//        print("Total squares: \(totalSquares)")
//    }
//    
//    private func setCellsView() {
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let numberOfColumns: CGFloat = 7 // days of the week
//        let numberOfRows: CGFloat = 6 // maximum rows needed
//        
//        let width = (collectionView.frame.size.width - 2 * (numberOfColumns - 1)) / numberOfColumns
//        let height = (collectionView.frame.size.height - 2 * (numberOfRows - 1)) / numberOfRows
//        flowLayout.itemSize = CGSize(width: width, height: height)
//    }
//    
//    private func setMonthView() {
//        totalSquares.removeAll()
//        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
//        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
//        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
//        
//        let totalDays = daysInMonth + startingSpaces
//        let totalSquaresNeeded = ((totalDays / 7) + (totalDays % 7 == 0 ? 0 : 1)) * 7
//        
//        for count in 1...totalSquaresNeeded {
//            if count <= startingSpaces || count - startingSpaces > daysInMonth {
//                totalSquares.append("")
//            } else {
//                totalSquares.append(String(count - startingSpaces))
//            }
//        }
//        
//        monthLabel.text = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
//        collectionView.reloadData()
//    }
//    
//    @IBAction func nextMonthPressed(_ sender: Any) {
//        selectedDate = calendarHelper.plusMonth(date: selectedDate)
//        setMonthView()
//    }
//
//    @IBAction func previousMonthButtonPressed(_ sender: Any) {
//        selectedDate = calendarHelper.minusMonth(date: selectedDate)
//        setMonthView()
//    }
//
//    // UICollectionViewDataSource Methods
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return totalSquares.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
//        cell.dayOfMonth.text = totalSquares[indexPath.item]
//        print("IndexPath: \(indexPath), Day: \(totalSquares[indexPath.item])") // Debug print
//        return cell
//    }
//
//    // Screen shouldn't rotate
//    override open var shouldAutorotate: Bool {
//        return false
//    }
//}

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let calendarHelper = CalendarHelper()
    var selectedDate = Date()
    var totalSquares = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setCellsView()
        setMonthView()
    }
    
    func setCellsView() {
        let numberOfColumns: CGFloat = 7
        let numberOfRows: CGFloat = 6
        
        let width = (collectionView.frame.size.width - 2 * (numberOfColumns - 1)) / numberOfColumns
        let height = (collectionView.frame.size.height - 2 * (numberOfRows - 1)) / numberOfRows
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        print("Collection view frame: \(collectionView.frame)")
        print("Flow layout item size: \(flowLayout.itemSize)")
    }
    
    func setMonthView() {
        totalSquares.removeAll()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        let totalDays = daysInMonth + startingSpaces
        let totalSquaresNeeded = ((totalDays / 7) + (totalDays % 7 == 0 ? 0 : 1)) * 7
        
        for count in 1...totalSquaresNeeded {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
        }
        
        print("Total squares: \(totalSquares)")
        monthLabel.text = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
        collectionView.reloadData()
    }
    
    @IBAction func nextMonthPressed(_ sender: Any) {
        selectedDate = calendarHelper.plusMonth(date: selectedDate)
        setMonthView()
    }

    @IBAction func previousMonthButtonPressed(_ sender: Any) {
        selectedDate = calendarHelper.minusMonth(date: selectedDate)
        setMonthView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items in section: \(totalSquares.count)")
        return totalSquares.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        let day = totalSquares[indexPath.item]
        cell.dayOfMonth.text = day.isEmpty ? " " : day
        print("Setting cell at \(indexPath) with day: \(day)")
        return cell
    }

    override open var shouldAutorotate: Bool {
        return false
    }
}
