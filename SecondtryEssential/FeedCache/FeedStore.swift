//
//  FeedStore.swift
//  SecondtryEssential
//
//  Created by Amir on 1/12/24.
//

import Foundation

public struct CachedFeed {
    public let feed: [LocalFeedItem]
    public let timestamp: Date
    
    public init(feed: [LocalFeedItem], timestamp: Date) {
        self.feed = feed
        self.timestamp = timestamp
    }
    
}

public protocol FeedStore {
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias DeletionResult = Result<Void, Error>
    typealias InsertionResult = Result<Void, Error>
    
    typealias DeletionCompletion = (DeletionResult) -> Void
    typealias InsertionCompletion = (InsertionResult) -> Void
    typealias RetrieveCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    /// The completion handler can be invoked in any thread. 
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
    /// The completion handler can be invoked in any thread. 
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrieveCompletion)
}

public struct LocalFeedItem: Equatable {
    
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
    
}

