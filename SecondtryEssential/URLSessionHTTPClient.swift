//
//  URLSessionHTTPClient.swift
//  SecondtryEssential
//
//  Created by Amir on 11/16/23.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    public init(session: URLSession = .shared) {
        self.session = session
    }
    private struct UnexpectedError: Error {}
    
    public func get(from URL: URL, completion: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void) {
        
        session.dataTask(with: URLRequest(url: URL)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, data.count > 0, let response = response as? HTTPURLResponse {
                completion(.success((response, data)))
            } else {
                completion(.failure(UnexpectedError()))
            }
        }.resume()
    }
}
