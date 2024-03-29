//
//  FeedItem.swift
//  SecondtryEssential
//
//  Created by Amir on 11/2/23.
//

import Foundation

public struct FeedImage: Equatable {
    
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = imageURL
    }
    
}
