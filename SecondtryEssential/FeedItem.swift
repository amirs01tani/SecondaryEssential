//
//  FeedItem.swift
//  SecondtryEssential
//
//  Created by Amir on 11/2/23.
//

import Foundation

public struct FeedItem: Equatable {
    
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    public init(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
    
}
