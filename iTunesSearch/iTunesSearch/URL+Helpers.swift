//
//  URL+Helpers.swift
//  iTunesSearch
//
//  Created by Mark Meretzky on 3/4/19.
//  Copyright © 2019 Caleb Hicks. All rights reserved.
//

import Foundation;

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        guard var components: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil;
        }
        components.queryItems = queries.map {URLQueryItem(name: $0.0, value: $0.1)}
        return components.url;
    }
}

