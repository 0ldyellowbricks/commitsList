//
//  CommitListTests.swift
//  CommitListTests
//
//  Created by Jing Zhao on 1/28/21.
//

import XCTest
@testable import CommitList

class CommitListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCommitModelAndCommitVM() {
        let cmit = CommitResult(sha: "sha111", commit: Commit(author: Author(name: "author222", date: "date2020"), message: "msg000"))
//        XCTAssertEqual(cmit.sha, "sha11")
        
        let cmitVM = CommitViewModel(commit: cmit)
//        XCTAssertEqual("sha112", cmitVM.sha)
        XCTAssertEqual(cmit.sha, cmitVM.sha)
    }

    func testMyConvertDateFormatter() {
        let originalDate = "2021-01-28T22:51:19Z"
        let convert = originalDate.my_convertDateFormatter()
        XCTAssertEqual(convert, "01-28-2021")
    }
}
