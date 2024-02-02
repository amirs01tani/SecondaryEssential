//
//  CodableFeedStore.swift
//  SecondtryEssential
//
//  Created by Amir on 1/26/24.
//

import Foundation

public class CodableFeedStore: FeedStore {
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct Cache: Codable {
        let feed: [CodableFeedItem]
        let timestamp: Date
    
    }
    
    private struct CodableFeedItem: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let imageURL: URL
        
        init(_ item: LocalFeedItem) {
            id = item.id
            description = item.description
            location = item.location
            imageURL = item.imageURL
        }
        
        var local: LocalFeedItem {
            return LocalFeedItem(id: id,description: description, location: location, imageURL: imageURL)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos:.userInitiated, attributes: .concurrent)

    public func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard let data = try? Data (contentsOf: storeURL) else { return completion(.success(.none)) }
            let decoder = JSONDecoder()
            do {
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.success(CachedFeed(feed: cache.feed.map { $0.local }, timestamp: cache.timestamp)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedItem], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            let encoder = JSONEncoder()
            let encoded = try! encoder.encode(Cache(feed: feed.map(CodableFeedItem.init), timestamp: timestamp))
            do {
                try encoded.write(to: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(.success(()))
            }
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
