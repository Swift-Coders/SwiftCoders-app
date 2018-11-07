//
//  GroupsViewController.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 9/12/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit
import MapKit
import EventKit
import BEMCheckBox

final class EventDetailsViewController: UIViewController {
    var object: EventData!
    let eventStore = EKEventStore()
    
    @IBOutlet weak var checkmarkAnimation: BEMCheckBox!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var dateNameLabel: UILabel!
    @IBOutlet var mapView: MKMapView! {
        didSet {
            mapView.layer.cornerRadius = 10
            mapView.isScrollEnabled = false
            mapView.isRotateEnabled = false
            mapView.isZoomEnabled = false
            mapView.isPitchEnabled = false
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpContent()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.showAnnotations([object.event.venue], animated: false)
        
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func addCalendarEvent(_ sender: Any) {
        confirmCalendarEvent()
    }
    
    
    
} // end of EventDetailsViewController



extension EventDetailsViewController: BEMCheckBoxDelegate {
    // MARK:- Custom Methods
    func setUpContent() {
        navigationItem.largeTitleDisplayMode = .never
        precondition(object != nil)
        
        checkmarkAnimation.delegate = self
        checkmarkAnimation.isHidden = true
        calendarButton.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        title = object.group.name
        groupNameLabel.text = object.event.name
        textView.text = object.event.description.html2String
        
        dateSetup()
        
        mapView.addAnnotation(object.event.venue)
    }
    
    
    func dateSetup() {
        let date = object.event.localDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        guard let startDate = dateFormatter.date(from: date) else { return }
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let newDate = dateFormatter.string(from: startDate)
        dateNameLabel.text = newDate
    }
    
    
    func addToCalendar() {
        //requestCalendarAccess()
        
        var eventAlreadyExists = false
        let event = EKEvent(eventStore: eventStore)
        let start = object.event.localDate
        
        
        let time = object.event.localTime
        let splitTime = time.split(separator: ":")
        guard let conv = Double(splitTime[0]) else { return }
        let newNumber = conv - 12
        let meetupStartTime = (conv * 60) * 60
        //get the time and convert it to a time interval so the calendar appointment has the meetup scheduled at the correct time
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: start) else { return }
        
        event.title = object.event.name
        event.startDate = startDate.addingTimeInterval(meetupStartTime)
        event.endDate = event.startDate + 7200
        event.notes = "Hello friend 🤖"
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        
        let predicate = eventStore.predicateForEvents(withStart: event.startDate, end: event.endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        
        
        for singleEvent in existingEvents {
            if singleEvent.title == event.title && singleEvent.startDate == event.startDate && singleEvent.endDate == event.endDate {
                
                eventAlreadyExists = true
                let alert = UIAlertController(title: "Event Exists", message: nil, preferredStyle: .alert )
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {
                    action in
                    print("event already exists")
                })
                
                alert.addAction(ok)
                self.present(alert, animated: true)
                break
            }
        }
        
        if !eventAlreadyExists {
            do {
                didTap(checkmarkAnimation)
                try eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("error: \(error)")
            }
            
            print("save event")
        }
        
    }
    
    
    func confirmCalendarEvent() {
        requestCalendarAccess()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addEvent = UIAlertAction(title: "Add to calendar", style: .default, handler: {
            action in
            
            self.addToCalendar()
            print("added to calendar")
        })
        
        // style must be .cancel then it will automatically give space from the previous action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
            print("Didnt want to add to calendar")
        })
        
        alert.addAction(addEvent)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) {
            (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
            } else {
                print("error: \(error)")
            }
        }
        
    }
    
    
    func didTap(_ checkBox: BEMCheckBox) {
        textView.isHidden =  true
        checkmarkAnimation.isHidden = false
        checkmarkAnimation.isEnabled = true
        checkmarkAnimation.animationDuration = 1.5
        checkmarkAnimation.setOn(true, animated: true)
    }
    
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        textView.isHidden = false
        checkmarkAnimation.isHidden = true
        checkmarkAnimation.isEnabled = false
        
        checkmarkAnimation.setOn(false, animated: true)
        //a delegate method automatically called whent the animation is complete
    }
    
    
    
    
} // end of extension



extension EventDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }
    
    
} // end of extension




extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
} // end of extension


extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
} // end of extension

