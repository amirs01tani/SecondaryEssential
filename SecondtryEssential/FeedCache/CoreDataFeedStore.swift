//
//  CoreDataFeedStore.swift
//  SecondtryEssential
//
//  Created by Amir on 1/28/24.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
    public init(){}
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrieveCompletion) {
        completion(.empty)
    }
    
    
}
