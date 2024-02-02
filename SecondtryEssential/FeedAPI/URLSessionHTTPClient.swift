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
            // MARK: - old school
            //            if let error = error {
            //                completion(.failure(error))
            //            } else if let data = data, let response = response as? HTTPURLResponse {
            //                completion(.success((response, data)))
            //            } else {
            //                completion(.failure(UnexpectedError()))
            //            }
            
            
            // MARK: - new Result API feature
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (response, data)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }.resume()
    }
}

struct UnexpectedValuesRepresentation: Error {}
