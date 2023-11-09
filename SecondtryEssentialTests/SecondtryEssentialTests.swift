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
        let clientError = NSError(domain: "Test", code: 0)
        
        expect(sut: sut, toCompleteWith: .failure(.connectivity)) {
            client.complete(with: clientError)
        }
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let codes = [199, 201, 300, 400, 500]
        codes.enumerated().forEach({ index, code in
            let data = Data("{\"items\": []}".utf8)
            expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, data: data, at: index)
            }
            
        })
    }
    
    func test_load_deliversInvalidErrorOnInvalid200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let data = Data("invalid data".utf8)
        
        expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_load_deliversNoItemOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        
        let data = Data("{\"items\": []}".utf8)
        
        expect(sut: sut, toCompleteWith: .success([])) {
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://a-url.com")!)
        let item2 = makeItem(id: UUID(), imageURL: URL(string: "http://another-url.com")!)
        
        expect(sut: sut, toCompleteWith: .success([item1.item, item2.item])) {

            client.complete(withStatusCode: 200, data: makeItemsJSON(items: [item1.json, item2.json]))
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let url = URL(string: "http://a-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client, url: url)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON(items: []))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK: - Helpers
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (item: FeedItem, json: [String: Any]){
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        return (item, json)
    }
    
    private func makeItemsJSON(items: [[String: Any]]) -> Data {
        let itemsJSON = ["items": items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
        
    }
    
    private func expect(sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: ()->Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeSUT(url: URL = URL(string: "http://a-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        trackForMemoryLeak(object: client)
        trackForMemoryLeak(object: sut)
        return (sut, client)
    }
    
    private func trackForMemoryLeak(object: AnyObject, file: StaticString = #file, line: UInt = #line ) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Potential memory leak")
        }
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


