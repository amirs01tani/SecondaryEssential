//
//  FeedItemLoader.swift
//  SecondtryEssential
//
//  Created by Amir on 11/2/23.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}

public protocol HTTPClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from URL: URL, completion: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void)
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
    
    public enum Result: Equatable {
        case success([FeedImage])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .success((response, data)):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
            
        })
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do
        {
            let items = try FeedItemsMapper.map(data: data, response: response)
            return . success(items.toModels())
        }
        catch {
            return . failure(.invalidData)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location,
                              imageURL: $0.image) }
    }
}

public struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedImage {
        return FeedImage(id: id, description: description, location: location, imageURL: image)
    }
}

public class FeedItemsMapper {
    private struct root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
    
}
