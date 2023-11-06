//
//  FeedItemLoaderTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 11/2/23.
//

import XCTest
import SecondtryEssential

class FeedItemLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    func test_init_requestDataFromURL() {
        let url = URL(string: "http://a-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load { capturedError.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.messages[0].completion(clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from URL: URL, completion: @escaping (Error) -> Void) {
            self.messages.append((URL, completion))
        }
        
        var requestedURLs: [URL] {
            messages.map({ $0.url })
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
        
        var messages = [(url: URL, completion: (Error) -> Void)]()

    }

}


