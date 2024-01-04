//
//  TestHelpers.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "", code: 1)
}
