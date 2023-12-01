//
//  MemoryLeakTracker.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/2/23.
//

import Foundation
import XCTest

extension XCTestCase {
    
    public func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file,
                         line: line)
        }
    }
}
