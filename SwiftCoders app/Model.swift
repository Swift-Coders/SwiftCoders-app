//
//  Model.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation
import MapKit

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
    let description: String
    let yesRsvpCount: Int
    let localDate: String
    let localTime: String
    let venue: Venue

    class Venue: NSObject, Codable {
        let name: String
        let lat: Double
        let lon: Double
        let address1: String
        let city: String
        let state: String
        let zip: String
    }
}

struct EventData {
    var group: MeetupGroup
    var event: MeetupEvent
}

extension MeetupEvent.Venue: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    var title: String? {
        return name
    }

    var subtitle: String? {
        return address1
    }
}
