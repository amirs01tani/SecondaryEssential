//
//  FeedStoreSpy.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/12/24.
//

import Foundation
import SecondtryEssential

public class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedItem], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    public var deletionCompletions = [DeletionCompletion]()
    public var insertCompletions = [InsertionCompletion]()
    public var retrivalCompletions = [RetrieveCompletion]()
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    public func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    public func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    public func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(items, timestamp))
        insertCompletions.append(completion)
    }
    
    public func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](.failure(error))
    }
    
    public func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletions[index](.success(()))
    }
    
    public func retrieve(completion: @escaping RetrieveCompletion) {
        retrivalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    public func completeRetrieval(with error: Error, at index: Int = 0) {
        retrivalCompletions[index](.failure(error))
    }
    
    public func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrivalCompletions[index](.success(.none))
    }
    
    public func completeRetrieval(with data: [LocalFeedItem], timeStamp: Date, at index: Int = 0) {
        retrivalCompletions[index](.success(CachedFeed(feed: data, timestamp: timeStamp)))
    }
    
}
