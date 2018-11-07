//
//  EventsViewController.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 9/12/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

final class EventsViewController: UITableViewController {
    private func loadEvents(completion: @escaping (Events) -> Void) {
        var returnGroups: Events = [:]

        MeetupAPI.getGroups { (groups) in
            groups.forEach { group in
                MeetupAPI.getEvent(group: group) { events in
                    print("\(group): \(events)")
                    returnGroups[group] = events

                    if group == groups.last {
                        completion(returnGroups)
                    }
                }
            }
        }
    }
    

    typealias Events = [MeetupGroup: [MeetupEvent]]
    private var events: Events = [:] {
        didSet {
            eventsArray = []
            for (group, events) in events {
                for event in events {
                    eventsArray.append(EventData(group: group, event: event))
                }
            }
        }
    }
    private var eventsArray: [EventData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // removed back text on nav bar
        let emptyBackButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.backBarButtonItem = emptyBackButton
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        //remove lines on the tableView
        
        loadEvents { events in
            self.events = events
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventVC = segue.destination as? EventDetailsViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {

            let object = eventsArray[indexPath.row]
            eventVC.object = object
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventCell

        let object = eventsArray[indexPath.row]
        cell.configure(model: object)

        return cell
    }

    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        viewController.object = eventsArray[indexPath.row]
        show(viewController, sender: nil)
    }*/
}

final class EventCell: UITableViewCell {
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateNameLabel: UILabel!
}

private extension EventCell {
    func configure(model: EventData) {
        groupNameLabel.text = model.group.name
        eventNameLabel.text = model.event.name
        
        let date = model.event.localDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        guard let startDate = dateFormatter.date(from: date) else { return }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let newDate = dateFormatter.string(from: startDate)
        
        dateNameLabel.text = newDate
    }
    
}

