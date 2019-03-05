//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Mark Meretzky on 3/4/19.
//  Copyright © 2019 Caleb Hicks. All rights reserved.
//

import Foundation;

struct StoreItem: Codable {
    var trackName: String;
    var artistName: String;
    var kind: String;
    var artworkUrl100: URL;
    var shortDescription: String;
    
    enum CodingKeys: String, CodingKey {
        case trackName;
        case artistName;
        case kind;
        case artworkUrl100;
        case shortDescription;
    }
    
    enum AdditionalKeys: String, CodingKey {
        case longDescription;
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self);
        
        trackName    = try  valueContainer.decode(String.self, forKey: CodingKeys.trackName);
        artistName   = try  valueContainer.decode(String.self, forKey: CodingKeys.artistName);
        kind         = try  valueContainer.decode(String.self, forKey: CodingKeys.kind);
        artworkUrl100 = try  valueContainer.decode(URL.self, forKey: CodingKeys.artworkUrl100);
        
        if let shortDescription: String = try? valueContainer.decode(String.self, forKey: CodingKeys.shortDescription) {
            self.shortDescription = shortDescription;
        } else {
            let additionalValues: KeyedDecodingContainer<AdditionalKeys> = try decoder.container(keyedBy: AdditionalKeys.self);
            shortDescription = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? "";
        }
    }
}

struct StoreItems: Codable {
    var results: [StoreItem];
}
