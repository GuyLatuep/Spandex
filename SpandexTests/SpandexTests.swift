//
//  SpandexTests.swift
//  SpandexTests
//
//  Created by Malte Polzin on 21.10.23.
//

import XCTest
@testable import Spandex

final class SpandexTests: XCTestCase {

    func testSnippingMatching() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        /**
         example xname
         ##should Match
         -xname
         - xname
         -the xname
         ##shouldn´t match
         -xnot
         -xnam
         -theuxname
         */
        let snippet = Snippet(trigger: "xname", content: "Malte Polzin")
        XCTAssert(snippet.matches("xname"))
        XCTAssert(snippet.matches(" xname"))
        XCTAssert(snippet.matches("the xname"))
        XCTAssert(!snippet.matches("xnot"))
        XCTAssert(!snippet.matches("xnam"))
        XCTAssert(!snippet.matches("theuxname"))
    }
}
