//
//  URLSessionHTTPClient.swift
//  SecondtryEssential
//
//  Created by Amir on 11/16/23.
//

import Foundation

public enum HTTPClientResult{
    case success(data: Data?,response: HTTPURLResponse?)
    case failure(error: Error?)
}

public class URLSessionHTTPClient {
    private let session = URLSession.shared
    
    public init() {}
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult)->Void) {
        session.dataTask(with: URLRequest(url: url)) { _,_, error in
            if let error = error {
                completion(.failure(error: error))
            }
        }.resume()
    }
}
