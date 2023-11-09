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
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURL() {
        let url = URL(string: "http://a-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedResult = [RemoteFeedLoader.Result]()
        sut.load { capturedResult.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedResult, [.failure(.connectivity)])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let codes = [199, 201, 300, 400, 500]
        codes.enumerated().forEach({ index, code in
            var capturedResult = [RemoteFeedLoader.Result]()
            sut.load { capturedResult.append($0) }
            let data = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: code, data: data, at: index)
            XCTAssertEqual(capturedResult, [.failure(.invalidData)])
        })
    }
    
    func test_load_deliversInvalidErrorOnInvalid200HTTPResponse() {
        let (sut, client) = makeSUT()
        var capturedResult = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResult.append($0) }
        let data = Data("invalid data".utf8)
        
        client.complete(withStatusCode: 200, data: data, at: 0)
        
        XCTAssertEqual(capturedResult, [.failure(.invalidData)])
    }
    
    //MARK: - Helpers
    
    private func expect(sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: ()->Void) {
        
    }
    
    private func makeSUT(url: URL = URL(string: "http://a-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from URL: URL, completion: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void) {
            self.messages.append((URL, completion))
        }
        
        var requestedURLs: [URL] {
            messages.map({ $0.url })
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((response, data)))
        }
        
        var messages = [(url: URL, completion: (Result<(HTTPURLResponse, Data), Error>) -> Void)]()

    }

}


