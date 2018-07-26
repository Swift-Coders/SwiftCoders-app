//
//  MeetupAPI2.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation
import Moya

enum MeetupAPI2 {
    static let provider = MoyaProvider<MeetupAPI2>()
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    case getGroups
    case getEvents(MeetupGroup)
}

extension MeetupAPI2: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.meetup.com")!
    }

    var path: String {
        switch self {
        case .getGroups: return "/self/groups"
        case .getEvents(let group): return "/\(group.urlname)/events"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestParameters(parameters: ["key": "1e5d2a74f1f471c378542b3d4d17f"], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }

    var sampleData: Data { return Data() }
}
