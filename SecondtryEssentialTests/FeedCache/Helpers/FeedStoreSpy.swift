//
//  FeedStoreSpy.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/12/24.
//

import Foundation
import SecondtryEssential

public typealias DeletionCompletion = (Error?) -> Void
public typealias InsertionCompletion = (Error?) -> Void

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
        deletionCompletions[index](error)
    }
    
    public func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    public func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(items, timestamp))
        insertCompletions.append(completion)
    }
    
    public func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](error)
    }
    
    public func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletions[index](nil)
    }
    
    public func retrieve(completion: @escaping RetrieveCompletion) {
        retrivalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    public func completeRetrieval(with error: Error, at index: Int = 0) {
        retrivalCompletions[index](.failure(error))
    }
    
    public func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrivalCompletions[index](.empty)
    }
    
    public func completeRetrieval(with data: [LocalFeedItem], timeStamp: Date, at index: Int = 0) {
        retrivalCompletions[index](.found(feed: data, timestamp: timeStamp))
    }
    
}
