//
//  FeedStoreTestSpec.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/28/24.
//

import Foundation

protocol FeedStoreSpecs {

        func test_retrieve_emptyOnEmptyCache()
        func test_retrieve_hasNoSideEffectsOnEmptyCache()
        func test_retrieve_deliversFoundValueOnNonEmptyCache()
        func test_retrieve_hasNoSideEffectOnNonEmptyCache()

        func test_insert_deliversNoErrorOnEmptyCache()
        func test_insert_deliversNoErrorOnNonEmptyCache()
        func test_insert_overridesPreviouslyInsertedCachedValues()

        func test_delete_deliversNoErrorOnEmptyCache()
        func test_delete_hasNoSideEffectsOnEmptyCache()
        func test_delete_deliversNoErrorOnNonEmptyCache()
        func test_delete_emptiesPreviouslyInsertedCache()
        
        func test_inRaceCondition_queriesRunserially()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_retrieve_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
