//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Mark Meretzky on 3/4/19.
//  Copyright © 2019 Caleb Hicks. All rights reserved.
//

import Foundation;

struct StoreItemController {
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        guard let baseURL: URL = URL(string: "https://itunes.apple.com/search?") else {
            print("could not create baseURL");
            completion(nil);
            return;
        }
        
        guard let searchURL: URL = baseURL.withQueries(query) else {
            print("could not create searchURL");
            completion(nil);
            return;
        }
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: searchURL) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data: Data = data else {
                print("no data was returned");
                completion(nil);
                return;
            }
            
            /*
            guard let string: String = String(data: data, encoding: .utf8) else {
                fatalError("could not change Data into String");
            }
            print(string);
            */
            
            let jsonDecoder: JSONDecoder = JSONDecoder();
            
            if let storeItems: StoreItems = try? jsonDecoder.decode(StoreItems.self, from: data) {
                completion(storeItems.results);
            } else {
                print("data was not properly serialized.");
                completion(nil);
            }
        }
        
        task.resume();
    }
}
