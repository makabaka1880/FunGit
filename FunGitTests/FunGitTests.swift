//
//  FunGitTests.swift
//  FunGitTests
//
//  Created by SeanLi on 2022/11/14.
//

import XCTest
@testable import FunGit

final class FunGitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        print(FunGit.run("cd ~/Desktop/AssemblerFun; git log"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
