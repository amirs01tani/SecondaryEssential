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
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let clientError = NSError(domain: "Test", code: 0)
        let codes = [199, 201, 300, 400, 500]
        codes.enumerated().forEach({ index, code in
            var capturedError = [RemoteFeedLoader.Error]()
            sut.load { capturedError.append($0) }
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedError, [.invalidData])
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from URL: URL, completion: @escaping (HTTPURLResponse?, Error?) -> Void) {
            self.messages.append((URL, completion))
        }
        
        var requestedURLs: [URL] {
            messages.map({ $0.url })
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(nil, error)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            messages[index].completion(response, nil)
        }
        
        var messages = [(url: URL, completion: (HTTPURLResponse?, Error?) -> Void)]()

    }

}


