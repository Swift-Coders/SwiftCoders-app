//
//  ViewController.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        MeetupAPI.getGroups { (groups) in
            groups.forEach {
                MeetupAPI.getEvent(group: $0) { events in
                    print(events)
                }
            }
        }
    }


}

