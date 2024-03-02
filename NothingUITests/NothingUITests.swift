//
//  NothingUITests.swift
//  NothingUITests
//
//  Created by Jose Benitez on 2/16/24.
//

import XCTest
@testable import Nothing

final class NothingUITests: XCTestCase {
    
    let application = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testColectionViewPortraitLayouts() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let portrait = CGRect(x: 0, y: 0, width: 393, height: 852)
        let cellDimension = CGRect(x: 0.0, y: 144.0, width: 393.0, height: 340.6666666666667)
        let headerViewDimension = CGRect(x: 0.0, y: 59.0, width: 393.0, height: 85.0)
        let square = CGRect(x: 0, y: 0, width: portrait.width * 0.8, height: portrait.height * 0.36901)
        let collectionView = app.collectionViews["NothingCollectionView"]
        let headerView = collectionView.otherElements["NothingCollectionViewReusableView"]
        let collectionCell = app.collectionViews.cells["NothingCollectionViewCell00"] //indexPath [0, 0]
        let textView = collectionCell.textViews["NothingTextView"]
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.frame, portrait)
        XCTAssertEqual(collectionView.frame, portrait)
        XCTAssertEqual(collectionCell.frame, cellDimension)
        XCTAssertEqual(headerView.frame, headerViewDimension)
        XCTAssertEqual(textView.frame, cellDimension)
    }

    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
