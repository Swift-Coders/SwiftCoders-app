//
//  Model.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

struct MeetupGroup: Codable, Hashable {
    let name: String
    let urlname: String
    let city: String
    let members: Int
    let groupPhoto: Photo

    struct Photo: Codable, Hashable {
        let photoLink: URL
        let thumbLink: URL
    }
}

struct MeetupEvent: Codable {
    let name: String
    let status: String
    let yesRsvpCount: Int
    let localDate: String
    let localTime: String
    let venue: Venue

    struct Venue: Codable {
        let name: String
        let lat: Double
        let lon: Double
        let address1: String
        let city: String
        let state: String
        let zip: String
    }
}
