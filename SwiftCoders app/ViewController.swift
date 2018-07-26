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

        MeetupAPI2.provider.request(.getGroups) { result in
            switch result {
            case .success(let response):
                do {
                    let groups = try response.map([MeetupGroup].self, using: MeetupAPI2.decoder)
                    print(groups)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

        MeetupAPI.getGroups { (groups) in
            groups.forEach {
                MeetupAPI.getEvent(group: $0) { events in
                    print(events)
                }
            }
        }
    }


}

