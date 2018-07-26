//
//  Model.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

struct MeetupGroup: Codable {
    let name: String
    let urlname: String
    let city: String
    let members: Int
    let groupPhoto: Photo

    struct Photo: Codable {
        let photoLink: URL
        let thumbLink: URL
    }
}

struct EventGroup: Codable {
    let name: String
    let status: String
    let yesRsvpCount: Int
}
