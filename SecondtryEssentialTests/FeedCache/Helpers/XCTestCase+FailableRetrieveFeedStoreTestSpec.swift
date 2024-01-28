//
//  File.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/27/24.
//

import XCTest
import SecondtryEssential

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
            expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
        }

        func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
            expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
        }
}
