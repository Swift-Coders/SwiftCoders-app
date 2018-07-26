//
//  MeetupAPI.swift
//  SwiftCoders app
//
//  Created by Yariv Nissim on 7/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

struct MeetupAPI {
    private static let apiKey = "1e5d2a74f1f471c378542b3d4d17f"
    private static let baseURL = "https://api.meetup.com"
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func get<Decoded: Decodable>(endpoint: String, completion: @escaping ([Decoded]) -> Void) {
        get(endpoint: endpoint) { (decoded) in
            completion(decoded ?? [])
        }
    }

    static func get<Decoded: Decodable>(endpoint: String, completion: @escaping (Decoded?) -> Void) {
        guard var component = URLComponents(string: baseURL + endpoint)else { completion(nil); return }
        component.queryItems = [URLQueryItem(name: "key", value: MeetupAPI.apiKey)]
        guard let url = component.url else { completion(nil); return }

        URLSession(configuration: .default).dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }

            let result = try? MeetupAPI.decoder.decode(Decoded.self, from: data)
            completion(result)
        }.resume()
    }

    static func getGroups(completion: @escaping ([MeetupGroup]) -> Void) {
        get(endpoint: "/self/groups", completion: completion)
    }

    static func getEvent(group: MeetupGroup, completion: @escaping ([EventGroup]) -> Void) {
        get(endpoint: "/\(group.urlname)/events", completion: completion)
    }
}
