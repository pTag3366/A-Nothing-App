//
//  NothingTests.swift
//  NothingTests
//
//  Created by Jose Benitez on 2/16/24.
//

import XCTest
@testable import Nothing

final class NothingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testIndexPathCommaSeparatedStringRepresentation() {
        let row = Int.random(in: 0...10)
        let section = Int.random(in: 0...10)
        let indexPath = IndexPath(item: row, section: section)
        let string = String("\("," + section.description + "," + row.description)")
        XCTAssertEqual(string, indexPath.commaSeparatedStringRepresentation)
    }
    
    func testIndexPathFromNothingCollectionViewCellAccessibilityLabel() {
        let row = Int.random(in: 0...10)
        let section = Int.random(in: 0...10)
        let indexPath = IndexPath(item: row, section: section)
        let cell = NothingCollectionViewCell()
        cell.setAccessibilityLabel(with: indexPath.commaSeparatedStringRepresentation)
        
        XCTAssertEqual(indexPath, cell.indexPathFromAccessibilityLabel)
    }
    
    func testIndexPathFromNCVCAccessibilityLabelNotSet() {
        let cell = NothingCollectionViewCell()
        
        XCTAssertEqual([], cell.indexPathFromAccessibilityLabel)
    }
    
    func testTwoRectanglesIntersect() {
        let backgroundRect = CGRect(x: 0, y: 0, width: 100, height: 400)
        let overlappingRect = CGRect(x: 0, y: 200, width: 100, height: 300)
        let intersectingRect = backgroundRect.intersection(overlappingRect)
        XCTAssertTrue(intersectingRect.intersects(overlappingRect))
        XCTAssertEqual(intersectingRect, CGRect(x: 0, y: 200, width: 100, height: 200))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
