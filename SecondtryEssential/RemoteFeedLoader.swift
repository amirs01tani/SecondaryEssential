//
//  FeedItemLoader.swift
//  SecondtryEssential
//
//  Created by Amir on 11/2/23.
//

import Foundation

public struct FeedItemResult {
    let data: [FeedItem]
    let error: Error
}

public protocol FeedLoader {
    func load(completion: (FeedItemResult)-> ())
}

public protocol HTTPClient {
    func get(from URL: URL, completion: @escaping (Result<HTTPURLResponse, Error>) -> Void)
}

public class RemoteFeedLoader {
    
    let client: HTTPClient
    let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
            
        })
    }
    
}
