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
                    eventsArray.append((group, event))
                }
            }
        }
    }
    private var eventsArray: [(group: MeetupGroup, event: MeetupEvent)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents { events in
            self.events = events
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
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
}

final class EventCell: UITableViewCell {
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateNameLabel: UILabel!
}

private extension EventCell {
    func configure(model: (group: MeetupGroup, event: MeetupEvent)) {
        groupNameLabel.text = model.group.name
        eventNameLabel.text = model.event.name
        dateNameLabel.text = model.event.localDate + " " + model.event.localTime
    }
}
