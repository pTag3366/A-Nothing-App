//
//  NothingTests.swift
//  NothingTests
//
//  Created by Jose Benitez on 2/16/24.
//

import XCTest
@testable import Nothing

final class NothingTests: XCTestCase {
    
    var dateComponents: DateComponents = {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2024
        return dateComponents
    }()
    let testNotes: Data = """
    {
        "dateCreated": 123456,
        "dateString": "Tuesday, Mar 26, 2024",
        "lastModified": 123456,
        "textData": [],
        "url": "ED5F86DF-B1EC-48BD-A6E2-09D6468F282C",
        "uuid": "ED5F86DF-B1EC-48BD-A6E2-09D6468F282C"
    }
    """.data(using: .utf8)!
    let testList: Data = """
    [
        {
            "dateCreated": 123456,
            "dateString": "Tuesday, Mar 26, 2024",
            "lastModified": 123456,
            "textData": [],
            "url": "ED5F86DF-B1EC-48BD-A6E2-09D6468F282C",
            "uuid": "ED5F86DF-B1EC-48BD-A6E2-09D6468F282C"
        }
    ]
    """.data(using: .utf8)!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotesInitFromDecoder() throws {
        let note = try JSONDecoder().decode(Notes.self, from: testNotes)
        XCTAssertNotNil(note.dictionaryValue)
    }
    
    func testNotesListInitFromDecoder() throws {
        let list = try JSONDecoder().decode(NotesList.self, from: testList)
        XCTAssertEqual(list.notes.count, 1)
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
    
    func testDateComponentsReturnsValidDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        for day in stride(from: 1, through: 365, by: Int.random(in: 0...28)) {
            let month = (day/30)
            dateComponents.year = 2024
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = Int.random(in: 0...23)
            dateComponents.minute = Int.random(in: 0...59)
            dateComponents.second = Int.random(in: 0...59)
            for _ in stride(from: 1, through: Int.random(in: 1...5), by: 1) {
                guard let date = dateComponents.date else { return }
                _ = dateFormatter.string(from: date)
            }
            
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
