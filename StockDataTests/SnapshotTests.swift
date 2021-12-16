//
//  SnapshotTests.swift
//  StockDataTests
//
//  Created by Matthew Ramsden on 12/16/21.
//

import XCTest
@testable import StockData
import SnapshotTesting
import SwiftUI

class SnapshotTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testSnapshots() async {
        let viewModel = ResponseViewModel(
            fetch: { try await StockDataAPI.mock.fetch() }
        )
        await viewModel.loadArticles()
        
        let view = await ContentView(viewModel: viewModel)
        let vc = await UIHostingController(rootView: view)
        // vc.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX(.portrait)))

        if let data = viewModel.stocks {
            XCTAssertEqual(data.first?.lastText, Welcome.previewData.first?.lastText)
        } else {
            XCTFail("Loaded articles do not match")
        }
    }

}
